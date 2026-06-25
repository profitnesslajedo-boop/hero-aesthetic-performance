# HERO OS V5.6 No Float + All Classes Fix

## Correções
- Bloqueio global de qualquer CTA flutuante antigo da Comunidade HERO.
- Guarda em appendChild e insertBefore para impedir recriação do botão antes de entrar no DOM.
- Remoção imediata de botões flutuantes existentes.
- Aulas/cards/listas de aula forçados para visibilidade total, sem altura travada e sem overflow cortando.
- Sem MutationObserver no novo patch.
- Sem setInterval no novo patch.

## Auditoria
{
  "js_ok": true,
  "v56_marker": true,
  "global_float_block_css": true,
  "append_guard_present": true,
  "insert_guard_present": true,
  "floating_detector_present": true,
  "classes_visibility_css": true,
  "show_all_classes_js": true,
  "no_mutation_observer_v56": true,
  "no_setinterval_v56": true,
  "supabase_preserved": true,
  "student_ai_preserved": true,
  "loads_preserved": true,
  "series_preserved": true
}

## Validações
- JavaScript: node --check OK.
- Links estáticos OK.
