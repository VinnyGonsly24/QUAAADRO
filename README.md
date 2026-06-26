# QUAAADRO

App visual de planejamento e organizacao, em formato PWA, pronto para publicar no GitHub Pages.

## Publicacao

Os arquivos publicaveis ficam em:

```text
web/
```

No GitHub Pages, publique a pasta `web` pela branch principal ou envie o conteudo dessa pasta para a raiz do site.

## Nuvem

O QUAAADRO usa Supabase para login e sincronizacao dos projetos entre computadores. Antes de usar o login no app, rode o SQL abaixo no painel do Supabase:

```text
supabase-quaaadro.sql
```

Os anexos grandes ficam preparados para Google Drive. O modelo de ponte esta em:

```text
docs/google-drive-apps-script.js
```

Depois de publicar essa ponte na outra conta Google, abra a janela `Nuvem` do app e preencha `Drive dos anexos` com o e-mail dessa conta, a URL da ponte e o token. Esse e-mail pode ser diferente do e-mail usado para entrar no QUAAADRO.
