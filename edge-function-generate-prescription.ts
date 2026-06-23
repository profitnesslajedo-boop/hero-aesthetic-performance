import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};

function jsonResponse(payload: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(payload), { status, headers: corsHeaders });
}

function getServiceKey() {
  const directKey =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ||
    Deno.env.get("HERO_SERVICE_ROLE_KEY") ||
    Deno.env.get("SUPABASE_SECRET_KEY");

  if (directKey) return directKey;

  const secretKeysJson = Deno.env.get("SUPABASE_SECRET_KEYS");
  if (secretKeysJson) {
    try {
      const parsed = JSON.parse(secretKeysJson);
      const firstKey = Object.values(parsed)[0];
      if (typeof firstKey === "string") return firstKey;
    } catch (_error) {
      return null;
    }
  }
  return null;
}

const prescriptionSchema = {
  type: "object",
  additionalProperties: false,
  properties: {
    nome_do_treino: { type: "string" },
    fase: { type: "string" },
    objetivo_do_treino: { type: "string" },
    observacoes: { type: "string" },
    dias: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        properties: {
          dia: { type: "string" },
          foco: { type: "string" },
          exercicios: {
            type: "array",
            items: {
              type: "object",
              additionalProperties: false,
              properties: {
                ordem: { type: "number" },
                nome: { type: "string" },
                traducao: { type: "string" },
                grupo: { type: "string" },
                categoria: { type: "string" },
                series: { type: "string" },
                repeticoes: { type: "string" },
                carga: { type: "string" },
                descanso: { type: "string" },
                metodo: { type: "string" },
                execucao: { type: "string" },
                observacoes: { type: "string" }
              },
              required: ["ordem","nome","traducao","grupo","categoria","series","repeticoes","carga","descanso","metodo","execucao","observacoes"]
            }
          }
        },
        required: ["dia", "foco", "exercicios"]
      }
    }
  },
  required: ["nome_do_treino", "fase", "objetivo_do_treino", "observacoes", "dias"]
};

Deno.serve(async (req) => {
  try {
    if (req.method === "OPTIONS") return new Response("ok", { status: 200, headers: corsHeaders });
    if (req.method !== "POST") return jsonResponse({ error: "Método não permitido." }, 405);

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) return jsonResponse({ error: "Usuário não autenticado." }, 401);

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = getServiceKey();
    const openaiApiKey = Deno.env.get("OPENAI_API_KEY");

    if (!supabaseUrl || !serviceRoleKey) return jsonResponse({ error: "Supabase URL ou service key não configurados." }, 500);
    if (!openaiApiKey) return jsonResponse({ error: "OPENAI_API_KEY não configurada nas Secrets." }, 500);

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
      global: { headers: { Authorization: `Bearer ${serviceRoleKey}` } },
    });

    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: userError } = await admin.auth.getUser(token);

    if (userError || !user) {
      return jsonResponse({ error: "Sessão inválida. Faça login novamente como treinador.", detail: userError?.message }, 401);
    }

    const { data: profile, error: profileError } = await admin
      .from("profiles")
      .select("role, status")
      .eq("id", user.id)
      .single();

    if (profileError || !profile) {
      return jsonResponse({ error: "Perfil do treinador não encontrado.", detail: profileError?.message }, 403);
    }

    if (profile.role !== "admin" || profile.status !== "ativo") {
      return jsonResponse({ error: "Apenas treinador/admin ativo pode gerar prescrições com IA." }, 403);
    }

    const body = await req.json();
    const {
      aluno_id,
      objetivo,
      nivel = "intermediário",
      dias_semana = 5,
      tempo_por_treino = "50 a 60 minutos",
      foco = "estética, força e resistência",
      restricoes = "",
      observacoes = "",
      salvar = true
    } = body;

    if (!aluno_id) return jsonResponse({ error: "aluno_id é obrigatório." }, 400);

    const { data: aluno, error: alunoError } = await admin
      .from("alunos")
      .select("*")
      .eq("id", aluno_id)
      .single();

    if (alunoError || !aluno) {
      return jsonResponse({ error: "Aluna não encontrada.", detail: alunoError?.message }, 404);
    }

    const systemPrompt = `
Você é o assistente técnico de prescrição do método HERO Aesthetic Performance, criado por Marcos Esteves.

Você trabalha para o treinador, não para a aluna. Seu papel é gerar uma sugestão técnica para revisão humana.

Princípios:
- Prioridade principal: estética muscular.
- Complementos: força real, condicionamento híbrido, blindagem articular e execução técnica.
- Base: musculação estética, progressão de carga, execução precisa, métodos avançados com critério e proteção articular.
- Evite prescrições perigosas, extremas ou incompatíveis com restrições.
- Se houver dor ou limitação, adapte o exercício.
- Não dê diagnóstico médico.
- Não prometa cura.
- Use português do Brasil.
- Entregue apenas dados estruturados no schema solicitado.
`;

    const userPrompt = {
      aluno: {
        nome: aluno.nome,
        email: aluno.email,
        objetivo_atual: aluno.objetivo,
        plano: aluno.plano,
        status: aluno.status
      },
      pedido_do_treinador: {
        objetivo,
        nivel,
        dias_semana,
        tempo_por_treino,
        foco,
        restricoes,
        observacoes
      }
    };

    const openaiResponse = await fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${openaiApiKey}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "gpt-5-mini",
        input: [
          { role: "system", content: systemPrompt },
          { role: "user", content: JSON.stringify(userPrompt) }
        ],
        text: {
          format: {
            type: "json_schema",
            name: "hero_prescription",
            strict: true,
            schema: prescriptionSchema
          }
        }
      })
    });

    const openaiPayload = await openaiResponse.json();

    if (!openaiResponse.ok) {
      return jsonResponse({ error: "Erro ao chamar OpenAI.", detail: openaiPayload }, 500);
    }

    const outputText =
      openaiPayload.output_text ||
      openaiPayload.output?.[0]?.content?.[0]?.text ||
      openaiPayload.output?.[1]?.content?.[0]?.text ||
      "";

    let prescription;
    try {
      prescription = typeof outputText === "string" ? JSON.parse(outputText) : outputText;
    } catch (_error) {
      return jsonResponse({ error: "A IA respondeu fora do formato JSON esperado.", detail: outputText }, 500);
    }

    await admin.from("ai_prescription_logs").insert({
      treinador_id: user.id,
      aluno_id,
      prompt: userPrompt,
      resposta: prescription,
      status: salvar ? "salvo" : "gerado"
    });

    if (!salvar) return jsonResponse({ success: true, mode: "preview", prescription });

    const { data: treino, error: treinoError } = await admin
      .from("treinos")
      .insert({
        aluno_id,
        nome_do_treino: prescription.nome_do_treino || "Prescrição HERO gerada por IA",
        fase: prescription.fase || "HERO IA",
        objetivo_do_treino: prescription.objetivo_do_treino || objetivo || "Estética, força e evolução real.",
        observacoes: prescription.observacoes || "Prescrição gerada por IA e pendente de revisão do treinador.",
        liberado: false,
        created_by: user.id
      })
      .select()
      .single();

    if (treinoError) return jsonResponse({ error: "Erro ao salvar treino.", detail: treinoError.message }, 400);

    const exercicios = [];
    for (const dia of prescription.dias || []) {
      for (const ex of dia.exercicios || []) {
        exercicios.push({
          treino_id: treino.id,
          aluno_id,
          dia: dia.dia,
          ordem: ex.ordem,
          nome: ex.nome,
          traducao: ex.traducao,
          grupo: ex.grupo,
          categoria: ex.categoria,
          series: ex.series,
          repeticoes: ex.repeticoes,
          carga: ex.carga,
          descanso: ex.descanso,
          metodo: ex.metodo,
          execucao: ex.execucao,
          observacoes: ex.observacoes
        });
      }
    }

    if (exercicios.length > 0) {
      const { error: exerciciosError } = await admin.from("exercicios_prescritos").insert(exercicios);
      if (exerciciosError) {
        return jsonResponse({ error: "Treino salvo, mas houve erro ao salvar exercícios.", detail: exerciciosError.message }, 400);
      }
    }

    return jsonResponse({ success: true, mode: "saved", treino, prescription });
  } catch (error) {
    return jsonResponse({ error: error?.message || "Erro interno na função." }, 500);
  }
});
