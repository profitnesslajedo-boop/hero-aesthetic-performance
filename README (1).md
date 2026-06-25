# HERO Components

Esta pasta inaugura a separação estrutural do front-end do HERO.

Nesta versão, a aplicação continua executando pelo `index.html` para preservar integralmente lógica, autenticação, banco, integrações e fluxos existentes.

A biblioteca visual oficial passa a existir em `/styles` e deve orientar qualquer futura extração real de componentes.

Componentes oficiais do Design System:

- Button: `.btn` e `.btn.secondary`
- Input: `input`, `textarea`, `select`, `.input`
- Card informativo: `.panel`, `.protocol`, `.today-panel`, `.workout-card`, `.exercise`, `.student-ex`, `.lib`
- Card métrica: `.stats div`, `.mini-grid span`
- Modal: `.modal`, `.modal-box`
- Badge/Status: `.badge`, `.status`

Nenhum novo componente deve receber estilo próprio fora dos tokens de `/styles/product-system-v60.css`.
