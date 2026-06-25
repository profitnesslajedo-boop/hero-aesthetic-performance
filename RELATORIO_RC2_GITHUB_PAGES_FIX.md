# HERO OS RC2 - Correção para GitHub Pages

## Problema identificado
A tela estava sendo exibida com HTML cru, fonte padrão do navegador e botões sem estilo. Isso indica falha de carregamento da camada CSS em produção, especialmente em GitHub Pages com projeto publicado dentro de subpasta.

## Correções aplicadas
- Adicionada referência explícita para `./styles/release-candidate-rc1.css` em `index.html` e `404.html`.
- Mantidos todos os caminhos locais como relativos, compatíveis com GitHub Pages em subpasta.
- Embutida uma cópia consolidada do CSS crítico dentro de `index.html` e `404.html`, garantindo que a interface carregue corretamente mesmo se o GitHub Pages falhar ao buscar algum CSS externo.
- Corrigidos scripts externos que possuíam conteúdo inline dentro de `<script src>`, comportamento ignorado pelo navegador.
- Protegidas chamadas de cronômetro/comunidade para não gerarem erro quando executadas antes da inicialização completa do app.
- Mantidos `supabase-config.js`, SQLs, autenticação, lógica, fluxos e integrações sem alteração.
- Criado arquivo `.nojekyll` para evitar processamento indesejado no GitHub Pages.

## Validações executadas
- Verificação de existência de arquivos locais referenciados.
- Validação de sintaxe JavaScript extraída de `index.html` e `404.html` com `node --check`.
- Teste de servidor estático local com estrutura simulando `/hero-aesthetic-performance/`.
- Verificação de resposta 200 para:
  - `index.html`
  - `404.html`
  - `supabase-config.js`
  - `styles/legacy-core.css`
  - `styles/release-candidate-rc1.css`

## Observação honesta de QA
A validação local confirmou estrutura, sintaxe e carregamento de arquivos estáticos. O teste completo com login real e dados Supabase deve ser feito após publicação, porque depende de rede, credenciais, tabelas, RLS e ambiente online.

## Instruções de publicação
Subir todos os arquivos e pastas da raiz do projeto para o repositório GitHub Pages. Não subir apenas `index.html`.

Estrutura obrigatória:

```
index.html
404.html
supabase-config.js
styles/
components/
pages/
.nojekyll
```

Não é necessário rodar SQL novo.
Não é necessário alterar Supabase.
Não é necessário alterar autenticação.
