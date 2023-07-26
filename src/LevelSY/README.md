# Sistema de Níveis (LevelSY)

Sistema de Níveis dos players com base no tempo jogado. Exibe no canto inferior da tela a informação de Nível e EXP com efeito fade-in/fade-out e o nome da música atual do rádio.

Possui sistema de verificação de inatividade. O player que passar de 2 minutos de inatividade irá parar de upar e exibirá um alerta na tela informando para digitar `/afk` para voltar a upar.

Adiciona a coluna do Nível dos players logados no Scoreboard. Alerta no chat quando um player upa de nível.

### Contagem de Experiência e Nível
- Player ganha 24 EXP a cada segundo jogado
- 86400 EXP para upar de nível (1 hora)

### Comandos:
+ `/afk` - Comando para voltar a upar caso ultrapasse 2 minutos de inatividade
