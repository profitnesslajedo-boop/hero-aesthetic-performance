# HERO OS RC3 — ajustes cirúrgicos solicitados

## Escopo preservado
- Banco de dados preservado.
- Supabase preservado.
- Autenticação preservada.
- Rotas existentes preservadas.
- Regras de negócio preservadas.
- Design System preservado.

## Correções aplicadas

### 1. Comunidade HERO
- Removida a renderização da seção Postagem Guiada.
- Removidos os modelos prontos da interface.
- Neutralizada a recriação automática dos modelos por scripts legados.
- Reorganizado o layout para não deixar espaço vazio.

### 2. Campo de imagem
- O input nativo de arquivo foi encapsulado visualmente.
- O texto exibido passou a ser Adicionar imagem.
- Corrigidos alinhamento horizontal, vertical, altura e padding.
- Mantida consistência visual com o Design System.

### 3. Check-in HERO
- Criado posicionamento estável para o card Check-in HERO.
- Card posicionado no topo da coluna lateral direita.
- Card Desafio da Semana permanece imediatamente abaixo.
- Largura, espaçamento e padrão visual preservados.

### 4. Botão Voltar
- Refeito o binding final do botão Voltar da comunidade.
- Para treinador, retorna ao centro de controle.
- Para aluna, retorna para a área individual/protocolo.
- Evento protegido contra listeners legados concorrentes.

### 5. Botão Meu Protocolo
- Refeito o binding final do botão Meu Protocolo.
- Corrigida resolução de aluno por alunoId, id ou e-mail local.
- Botão carrega a área individual da aluna sem depender de rota quebrada.

### 6. Cards dos treinos
- Refinamento aplicado apenas nos cards da página da aluna.
- Reduzido peso visual.
- Reduzidas bordas e sombras.
- Melhorados padding, espaçamento e hover discreto.
- Layout mantido, sem redesign geral.

### 7. Nomes dos treinos
- Foundation traduzido para Base de Performance.
- Patch preventivo aplicado para impedir exibição residual em textos renderizados.

## Validações executadas
- Verificação de referências locais: sem arquivos CSS/JS ausentes.
- Validação de sintaxe JavaScript em index.html: OK.
- Validação de sintaxe JavaScript em 404.html: OK.
- Verificação de compatibilidade com GitHub Pages: caminhos relativos mantidos.
- Verificação de .nojekyll: presente.
- Verificação estática de Foundation visível fora dos scripts: não encontrado.

## Observação técnica
O ambiente de execução bloqueou navegação headless para localhost/file por política interna do navegador do container. Por isso, a validação de clique foi reforçada por binding direto, análise estática, validação de sintaxe e preservação da renderização original. A validação final em produção deve ser feita após subir no GitHub Pages com o navegador real.
