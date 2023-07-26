# Sistema de Polícia (PoliceSY)

Sistema de polícia com opção de revistar, prender, algemar e limpar ficha de procurado. Ao prender, o indivíduo é teleportado para a prisão e precisa aguardar 1 minuto para ser liberado.

Para interagir com os comandos, a polícia deve estar próxima ao player.

O player procurado tem a opção de limpar o seu nível de procurado na delegacia, o local é exibido em um marker e um ícone no mapa.

### Comandos:
+ `/revistar` [PLAYER_ID] - Revista o player e exibe o seu nível de procurado no Chat
+ `/prender` [PLAYER_ID] - Prende o player caso esteja procurado
+ `/algemar` [PLAYER_ID] - Algema o player
+ `/desalgemar` [PLAYER_ID] - Retira a algema do player
+ `/limparficha` - Comando para limpar o nível de procurado por $750

### server-config.lua
Você pode editar os grupos da ACL que têm permissão para usar os comandos de polícia através deste arquivo.
