/*
HERO Supabase Adapter - base de integração.

Importante:
A versão atual do index.html está funcional em modo localStorage.
Este adapter mostra as operações que devem substituir gradualmente data()/save()
para operar com Supabase de verdade.

Ordem recomendada:
1. Criar projeto Supabase.
2. Executar supabase/schema.sql.
3. Executar supabase/seed_biblioteca_exercicios.sql.
4. Criar usuários em Authentication.
5. Preencher supabase-config.js.
6. Integrar este adapter ao index.html ou migrar para React/Vite.

*/

async function createHeroSupabaseClient() {
  if (!window.HERO_SUPABASE_CONFIG) {
    throw new Error("Arquivo supabase-config.js não encontrado.");
  }

  const { createClient } = window.supabase;
  return createClient(
    window.HERO_SUPABASE_CONFIG.url,
    window.HERO_SUPABASE_CONFIG.anonKey
  );
}

async function signInHero(email, password) {
  const supabase = await createHeroSupabaseClient();
  return supabase.auth.signInWithPassword({ email, password });
}

async function signOutHero() {
  const supabase = await createHeroSupabaseClient();
  return supabase.auth.signOut();
}

async function getProfileHero() {
  const supabase = await createHeroSupabaseClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();

  if (error) throw error;
  return data;
}

async function listAlunosHero() {
  const supabase = await createHeroSupabaseClient();
  const { data, error } = await supabase
    .from("alunos")
    .select("*")
    .order("data_cadastro", { ascending: false });

  if (error) throw error;
  return data;
}

async function getAlunoComTreinoHero(alunoId) {
  const supabase = await createHeroSupabaseClient();

  const { data: aluno, error: alunoError } = await supabase
    .from("alunos")
    .select("*")
    .eq("id", alunoId)
    .single();

  if (alunoError) throw alunoError;

  const { data: treinos, error: treinoError } = await supabase
    .from("treinos")
    .select("*, exercicios_prescritos(*)")
    .eq("aluno_id", alunoId)
    .order("data_criacao", { ascending: false });

  if (treinoError) throw treinoError;

  return { aluno, treinos };
}

async function criarAlunoHero({ nome, email, objetivo, plano, status }) {
  const supabase = await createHeroSupabaseClient();

  const { data, error } = await supabase
    .from("alunos")
    .insert([{ nome, email, objetivo, plano, status: status || "ativo" }])
    .select()
    .single();

  if (error) throw error;
  return data;
}

async function salvarTreinoHero(treino) {
  const supabase = await createHeroSupabaseClient();

  const { data, error } = await supabase
    .from("treinos")
    .upsert(treino)
    .select()
    .single();

  if (error) throw error;
  return data;
}

async function salvarExercicioHero(exercicio) {
  const supabase = await createHeroSupabaseClient();

  const { data, error } = await supabase
    .from("exercicios_prescritos")
    .upsert(exercicio)
    .select()
    .single();

  if (error) throw error;
  return data;
}

async function listarBibliotecaHero() {
  const supabase = await createHeroSupabaseClient();

  const { data, error } = await supabase
    .from("biblioteca_exercicios")
    .select("*")
    .order("grupo_muscular")
    .order("nome_exercicio");

  if (error) throw error;
  return data;
}

async function uploadFotoAlunaHero(file, userId) {
  const supabase = await createHeroSupabaseClient();

  const path = `${userId}/perfil-${Date.now()}.jpg`;

  const { data, error } = await supabase.storage
    .from("hero-fotos-alunas")
    .upload(path, file, { upsert: true, contentType: file.type });

  if (error) throw error;

  const { data: publicUrl } = supabase.storage
    .from("hero-fotos-alunas")
    .getPublicUrl(data.path);

  return publicUrl.publicUrl;
}
