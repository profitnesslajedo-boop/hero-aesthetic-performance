# HERO OS • Release Candidate RC1

## Escopo
Modo de estabilização pré-produção aplicado sobre a V61. Nenhuma funcionalidade nova foi criada. Banco de dados, Supabase, autenticação, APIs, permissões, SQLs e regras de negócio foram preservados.

## Correções aplicadas

### 1. Arquitetura e estabilidade
- Removidos scripts legados concorrentes V5.5, V5.6 e V57 que reprocessavam os mesmos elementos da comunidade.
- Eliminados monkey patches em `appendChild` e `insertBefore`, reduzindo risco de efeitos colaterais no DOM.
- Removido observador global amplo que reexecutava estabilizações em mutações de toda a página.
- Mantidos apenas os mecanismos necessários de renderização já existentes.

### 2. Comunidade HERO
- Consolidada a neutralização de botões flutuantes legados em um único script RC1.
- Preservados os botões oficiais dentro da navegação, toolbar, cards e contexto da comunidade.
- Protegido o fluxo contra retorno do botão inferior piscando.
- Corrigido risco de elementos duplicados de comunidade fora do fluxo oficial.

### 3. Design System e UI
- Adicionado `styles/release-candidate-rc1.css` como camada final de estabilidade visual.
- Padronizados estados de botões, inputs, modais, cards, áreas de IA e responsividade final.
- Reforçada proteção contra quebra de nomes de alunas.
- Reduzidos efeitos visuais agressivos e sombras desnecessárias na camada final.

### 4. Responsividade
- Ajustes finais para mobile, tablet, notebook e desktop.
- Proteção contra overflow horizontal.
- Ajuste de toolbar, ações contextuais, modal e IA da aluna em telas pequenas.

### 5. Performance
- Reduzidos reprocessamentos concorrentes.
- Removidas camadas redundantes de estabilização antiga.
- Mantidos os intervalos de cronômetro existentes, por serem funcionais.

## Validações executadas
- `index.html` e `404.html` possuem o mesmo conteúdo.
- Todos os arquivos CSS locais referenciados existem.
- `supabase-config.js` permanece na raiz.
- Sintaxe de todos os scripts inline validada com Node.js `vm.Script`.
- Servidor HTTP local validou carregamento dos arquivos principais com status 200.
- IDs estáticos duplicados: nenhum encontrado.
- Chamadas `onclick` para funções HERO: nenhuma referência quebrada encontrada.
- Scripts legados V5.5, V5.6 e V57: removidos.
- Monkey patches globais de DOM: removidos.

## Itens preservados
- Supabase
- SQLs
- Login
- Sessão
- Área do treinador
- Área da aluna
- Comunidade
- Chat/IA HERO
- Cronômetros
- Dados em localStorage
- Fluxos existentes

## Observação honesta de QA
A validação foi feita por análise estática, checagem de referências, sintaxe JS e servidor local. Testes conectados ao Supabase em ambiente real ainda devem ser executados após deploy, porque dependem das credenciais, tabelas, políticas RLS e dados reais do projeto.
