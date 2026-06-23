# HERO IA - correção de sincronização de exercícios

Esta versão corrige o problema em que a IA cria o treino e os exercícios no Supabase, mas a tela de prescrição abre sem exercícios.

## O que foi ajustado

- Ao abrir uma prescrição, o HTML busca os exercícios reais em `exercicios_prescritos`.
- Os exercícios são sincronizados para a tela local.
- Foi adicionado o botão `Sincronizar Supabase` dentro da tela da prescrição.

## Arquivos para subir no GitHub

Suba:
- index.html
- 404.html
- supabase-config.js

Os arquivos SQL e Edge Function estão incluídos apenas como backup.
