# Prompt mestre — texto exportado do documento-base

PROJETO: SIMULADOR MODULAR DE CRIAÇÃO E TESTE DE HABILIDADES

1. INSTRUÇÃO PRINCIPAL

Quero desenvolver um software de uso pessoal destinado à criação, personalização, composição e experimentação de habilidades em um ambiente de simulação visual.

Você deverá atuar como uma equipe multidisciplinar de profissionais especializados, representados por personas de IA, responsáveis por conduzir o projeto desde a descoberta dos requisitos até a especificação, arquitetura, implementação incremental e validação do software.

O objetivo não é simplesmente produzir uma aplicação que desenhe ataques na tela. Quero construir um simulador no qual eu possa elaborar habilidades detalhadas, combinar propriedades e efeitos, configurar alvos e observar como essas habilidades se comportam dentro de uma Sandbox.

A criação deverá oferecer bastante liberdade, mas também orientação contextual, organização e mecanismos para identificar configurações incompletas ou problemáticas.

O projeto ainda está em fase de descoberta. Você não possui todas as informações necessárias para especificar o funcionamento definitivo do sistema.

Por isso, sua primeira obrigação é me ajudar a descobrir e definir o produto antes de tomar decisões técnicas irreversíveis.

Não comece programando. Não presuma requisitos que ainda não aprovei. Não escolha definitivamente a tecnologia antes de entender as necessidades. Não confunda suas sugestões com decisões minhas.

Sua função é conduzir um processo profissional de descoberta e desenvolvimento, no qual cada etapa produza resultados verificáveis e seja validada antes de liberar a próxima.

2. VISÃO DO PRODUTO

2.1. Objetivo central

O simulador deverá permitir que eu crie habilidades a partir de características configuráveis, em vez de ficar restrito a uma biblioteca fechada de poderes predefinidos.

Quero poder definir como uma habilidade se manifesta, a que distância atua, quais propriedades possui, o que acontece quando é utilizada e como seus efeitos interagem com outras habilidades.

O sistema deverá ser flexível o suficiente para representar habilidades ofensivas, defensivas, passivas, de fortalecimento, de suporte e outras categorias que venham a ser necessárias.

Essas categorias ainda deverão ser investigadas. Não considere essa lista definitiva nem presuma que todas as habilidades precisam pertencer a uma única categoria.

A experiência principal será composta por duas partes integradas:

Um ambiente visual de experimentação, chamado Sandbox.

Um editor progressivo e personalizável para construir habilidades.

A Sandbox deverá ser o foco central da aplicação. O editor deverá possibilitar a criação das habilidades que serão experimentadas nesse ambiente.

A relação entre essas áreas deverá ser definida durante o levantamento de requisitos, incluindo a possibilidade de observar o ambiente enquanto configura uma habilidade.

2.2. Liberdade de composição

Não quero um sistema em que cada habilidade seja apenas um nome associado a um comportamento fixo.

Por exemplo, não quero depender exclusivamente de opções prontas como “Flecha Mágica”, “Bola de Fogo” ou “Corte de Vento”.

Quero poder configurar separadamente as propriedades que definem uma habilidade, de forma que diferentes combinações possam produzir resultados diferentes.

Uma habilidade poderá ser física, mágica, elemental ou possuir outras características, conforme o modelo que definirmos.

O usuário deverá ter liberdade para explorar combinações incomuns, desde que o sistema consiga representá-las ou informar claramente suas limitações.

As recomendações contextuais não poderão se transformar em restrições arbitrárias. O simulador poderá sugerir combinações mais coerentes com as escolhas feitas, mas não deverá impedir automaticamente uma combinação apenas por ela ser incomum.

A maneira de representar, validar e executar essas combinações será uma das decisões centrais do projeto.

3. A SANDBOX: O NÚCLEO DA APLICAÇÃO

3.1. Conceito visual

A Sandbox será um ambiente gráfico no qual poderei configurar a quantidade de bonecos ou alvos utilizados nos testes e experimentar as habilidades criadas.

Os bonecos deverão possuir uma representação visual simples e pixelizada.

Quero que a representação possa ser simplificada conforme a quantidade de bonecos aumenta. A intenção é preservar a legibilidade do ambiente e evitar que uma quantidade elevada de elementos prejudique a visualização ou o desempenho.

A solução exata deverá ser estudada. Não presuma que simplificar a representação visual significa obrigatoriamente reduzir a frequência de atualização, eliminar propriedades dos alvos ou alterar a lógica da simulação.

A representação gráfica e o processamento lógico deverão ser tratados como responsabilidades distintas sempre que isso for adequado à arquitetura escolhida.

3.2. Quantidade e organização dos alvos

O usuário deverá poder definir a quantidade de bonecos presentes no ambiente.

Ainda precisamos determinar:

Como os bonecos serão posicionados.

Se o posicionamento será automático, manual ou configurável.

Se será possível selecionar e configurar cada boneco individualmente.

Se haverá diferentes tipos de bonecos.

Se os bonecos serão estáticos, controláveis ou capazes de executar comportamentos próprios.

Quais atributos serão necessários para representar cada alvo.

Quais limites de quantidade serão aceitáveis.

Como o ambiente deverá se comportar quando houver muitos alvos.

Como serão representadas colisões, distâncias, áreas de efeito e outras interações, caso sejam necessárias.

Essas questões deverão ser investigadas por meio de perguntas. Não responda por mim.

3.3. Observação dos resultados

A Sandbox deverá permitir que eu observe os efeitos das habilidades.

Precisamos definir se a visualização deverá mostrar somente manifestações gráficas ou também informações numéricas e estados da simulação.

Investigue a necessidade de apresentar elementos como dano, duração, alterações de atributos, estados aplicados aos alvos, efeitos posteriores e outras informações que venham a ser aprovadas.

Não implemente painéis, indicadores ou recursos de análise antes de compreender quais informações realmente serão úteis para mim.

3.4. Requisitos de desempenho

A Sandbox deverá funcionar de maneira adequada às condições de uso pessoal que forem estabelecidas.

O desempenho deverá ser analisado considerando, entre outros fatores:

Quantidade de bonecos.

Quantidade de habilidades executadas.

Complexidade dos efeitos.

Duração e simultaneidade dos efeitos.

Complexidade visual das manifestações.

Frequência de atualização da simulação.

Não estabeleça metas numéricas arbitrárias. Primeiro investigue meu hardware, as quantidades esperadas e o nível de complexidade pretendido. Depois, proponha critérios mensuráveis para validar o desempenho.

4. EDITOR DE HABILIDADES

4.1. Princípio de criação progressiva

Quero uma interface ampla de personalização, mas não quero todas as propriedades da habilidade expostas simultaneamente em uma única tela.

O processo deverá ser interativo e progressivo.

O usuário deverá começar pelas características que determinam a direção geral da criação e, conforme avança, acessar opções mais específicas.

A estrutura poderá utilizar etapas, categorias, painéis, abas, navegação hierárquica ou outra solução. A escolha deverá ser fundamentada pela persona de UX/UI depois do levantamento dos requisitos.

A interface deverá permitir que o usuário compreenda o que está configurando, revise escolhas anteriores e aprofunde a personalização quando desejar.

Não presuma que uma criação necessariamente precisa seguir um fluxo linear e rígido. Investigue como equilibrar orientação e liberdade de navegação.

4.2. Separação conceitual das propriedades

O editor deverá distinguir propriedades que representam conceitos diferentes.

Entre as dimensões que já imagino estão:

Alcance: indica a distância ou faixa de atuação da habilidade, conforme a definição que adotarmos.

Formato: indica a forma de manifestação ou geometria da habilidade, como cone, feixe, laser, corte ou outras possibilidades.

Composição: indica a natureza ou composição da habilidade, incluindo possibilidades físicas, mágicas, elementais ou outras categorias que forem definidas.

Comportamento: representa como a habilidade atua, movimenta-se, manifesta-se ou interage com o ambiente.

Efeitos: representa as alterações produzidas no alvo, no usuário ou no ambiente.

Essas dimensões são uma visão inicial, não uma estrutura definitiva.

A equipe deverá investigar se existem outras dimensões necessárias, se alguma delas precisa ser subdividida e quais dependências existem entre elas.

Não misture conceitos diferentes em uma lista de habilidades prontas. A identidade completa da habilidade deverá resultar da combinação das características que o usuário configurar.

4.3. Seleções contextuais

O sistema deverá utilizar as escolhas anteriores para destacar opções potencialmente relevantes nas próximas etapas.

Por exemplo, se eu selecionar curta distância, o editor poderá destacar possibilidades como cortes, ataques concentrados, efeitos em área ou defesas de proximidade.

Se eu selecionar longa distância, poderá destacar feixes, disparos, esferas e outras possibilidades compatíveis.

Esses exemplos ilustram a experiência pretendida, mas não representam uma classificação fechada.

As opções contextuais deverão ser orientações úteis, não regras absolutas.

O sistema deverá preservar a possibilidade de selecionar características menos convencionais, desde que o usuário compreenda os possíveis impactos da escolha.

A equipe deverá investigar:

Como as opções serão agrupadas.

Como o sistema determinará quais opções merecem destaque.

Se opções incompatíveis serão ocultadas, desabilitadas ou apenas sinalizadas.

Como o usuário poderá ignorar recomendações.

Como serão tratadas combinações que ainda não possuam regras definidas.

Como a interface explicará por que determinada opção foi sugerida.

Não presuma que essas recomendações precisam de inteligência artificial em tempo de execução. Primeiro avalie se regras configuráveis são suficientes e quais mecanismos realmente agregariam valor.

4.4. Níveis de detalhamento

A interface deverá permitir que uma habilidade seja criada sem exigir que todas as propriedades possíveis sejam configuradas imediatamente.

Investigue a possibilidade de separar:

Configuração inicial.

Características complementares.

Comportamentos avançados.

Composição de efeitos.

Revisão e validação.

Esses nomes são provisórios.

O objetivo é evitar uma interface excessivamente carregada sem limitar a capacidade de criar habilidades complexas.

O usuário deverá compreender quais informações estão definidas, quais permanecem em aberto e quais podem ser configuradas posteriormente.

5. COMPOSIÇÃO E EXECUÇÃO DAS HABILIDADES

Esta seção é uma das partes mais importantes do projeto.

Não basta permitir que o usuário selecione uma forma visual e associe um valor de dano. Quero investigar como representar habilidades capazes de produzir diferentes efeitos e interagir entre si.

5.1. Exemplos da complexidade desejada

Os exemplos a seguir são referências para compreender a flexibilidade que procuro.

Exemplo A — Efeito persistente sobre o alvo

Uma habilidade atinge um boneco e aplica um efeito que continua atuando depois do impacto.

Exemplo B — Efeito posterior

Uma habilidade atinge um alvo e, após uma condição ser satisfeita, provoca outra ação, como teleportar o usuário para perto do alvo.

Exemplo C — Fortalecimento do usuário

Uma habilidade aumenta temporariamente o dano e a velocidade do usuário.

Exemplo D — Combinação de habilidades

O usuário ativa um fortalecimento e depois utiliza outra habilidade que aproveita as alterações provocadas pelo primeiro efeito.

Exemplo E — Passivas e auras

Uma passiva ou aura modifica o comportamento de outras habilidades enquanto determinadas condições forem satisfeitas.

Exemplo F — Habilidade com múltiplos comportamentos

Uma mesma habilidade pode combinar uma manifestação inicial, um impacto e efeitos adicionais, desde que essa composição seja compatível com as regras definidas.

Esses exemplos não estabelecem regras completas de combate. Eles demonstram que o modelo deverá ser suficientemente flexível para representar comportamentos compostos.

5.2. Perguntas necessárias para definir a lógica

A persona especializada em sistemas de habilidades deverá investigar, entre outros assuntos:

Como uma habilidade é ativada.

Quais condições permitem ou impedem sua execução.

Como os alvos são selecionados.

Como funcionam distância, área de atuação e colisões.

Como são representados efeitos imediatos e persistentes.

Como são definidos início, duração e término dos efeitos.

Como ações posteriores são desencadeadas.

Como os modificadores afetam outras habilidades.

Como são aplicadas passivas e auras.

Como diferentes efeitos interagem.

Como serão tratados efeitos acumuláveis, substituíveis ou mutuamente exclusivos.

Como são resolvidos conflitos entre modificadores.

Como o sistema reage a alvos que deixam de existir ou a condições que se tornam inválidas.

Como o usuário acompanha o resultado da execução.

Como o simulador representa comportamentos para os quais ainda não existem regras.

A lista deverá ser aprofundada conforme as respostas e os casos de uso.

Não transforme automaticamente cada possibilidade em uma funcionalidade obrigatória da primeira versão.

5.3. Separação entre definição, execução e visualização

A equipe deverá avaliar como separar conceitualmente:

A descrição configurável de uma habilidade.

As regras responsáveis por determinar seu comportamento.

O estado atual da simulação.

A representação visual dos acontecimentos.

Os registros e resultados que o usuário deseja observar.

A arquitetura técnica dependerá dessa análise.

O objetivo é evitar que as regras de uma habilidade fiquem inseparavelmente presas a uma animação específica ou a uma única tela da interface, caso essa separação seja necessária para suportar a complexidade desejada.

Não escolha um padrão arquitetural por moda. Justifique cada nível de abstração com base nos requisitos.

5.4. Limites e comportamentos indefinidos

Nem toda combinação imaginável necessariamente terá uma interpretação automática.

Quando o usuário criar uma combinação para a qual o simulador ainda não possua regras, o sistema deverá distinguir entre:

Uma combinação válida e executável.

Uma combinação incompleta que pode ser executada com limitações.

Uma combinação cuja execução exige uma decisão do usuário.

Uma combinação que não pode ser executada pela versão atual.

Essas categorias são propostas conceituais que deverão ser discutidas e refinadas.

Não invente resultados silenciosamente. O usuário deverá ser informado quando uma limitação do sistema impedir que a habilidade se comporte conforme sua intenção.

6. VALIDAÇÃO DA CRIAÇÃO E ALERTAS INTELIGENTES

6.1. Princípio geral

A ausência de uma informação não deverá impedir automaticamente a criação de uma habilidade.

Algumas propriedades serão obrigatórias para determinados comportamentos; outras serão opcionais, poderão receber valores padrão ou poderão permanecer indefinidas.

O sistema deverá analisar a configuração da habilidade antes de sua execução e identificar problemas relevantes para o comportamento pretendido.

Quando houver um problema que não impeça necessariamente a criação, o sistema deverá apresentar uma caixa de diálogo explicando o que foi identificado e perguntar se o usuário deseja continuar.

6.2. Exemplos de alertas

Os exemplos iniciais incluem:

Falta de dano definido quando o comportamento configurado exige dano.

Falta de alcance definido quando isso compromete a execução.

Ausência de informações necessárias para um efeito específico.

Combinações incompatíveis.

Comportamentos que ainda não são suportados pela implementação.

Configurações que podem produzir resultados ambíguos.

Esses exemplos não são uma lista definitiva.

O sistema deverá considerar o contexto. A falta de dano, por exemplo, não deve gerar um alerta indevido para uma habilidade que não causa dano.

O alerta deverá identificar o motivo, explicar sua consequência e oferecer uma escolha coerente.

6.3. Catálogo de motivos de validação

Os motivos dos alertas deverão ser representados de maneira estruturada, de modo que possam ser reutilizados, revisados e ampliados.

A equipe deverá propor como registrar:

Identificador do motivo.

Descrição compreensível.

Condição que desencadeia o alerta.

Características da habilidade relacionadas ao problema.

Consequência provável.

Gravidade ou categoria, caso isso seja útil.

Possíveis formas de correção.

Comportamento permitido após o aviso.

Esses campos são uma proposta inicial. A estrutura final deverá ser justificada.

O sistema deverá evitar alertas redundantes e não deverá tratar todo campo vazio como um erro.

6.4. Consequências de continuar

A equipe deverá definir o que acontece quando o usuário escolhe prosseguir com uma habilidade incompleta.

Entre as alternativas que poderão ser avaliadas estão executar a habilidade com limitações, utilizar valores padrão previamente definidos ou permitir a criação sem garantir que ela possa ser executada.

Não selecione uma dessas alternativas automaticamente.

O comportamento deverá ser consistente e compreensível. O usuário não deve ser levado a acreditar que a simulação foi executada corretamente quando, na realidade, alguma propriedade essencial foi ignorada.

Também precisamos distinguir alertas de criação, alertas de execução e avisos de limitações da versão atual.

7. AS PERSONAS PROFISSIONAIS

Organize o projeto em seis personas especializadas, com um gestor responsável pela coordenação e validação.

Se o ambiente não permitir agentes independentes, simule as seis personas de forma estruturada. Não afirme ter criado agentes autônomos ou executado processos externos sem que isso tenha acontecido.

Cada persona deverá ter responsabilidades delimitadas, entregáveis, critérios de conclusão e mecanismos de comunicação com as demais.

Persona 1 — Gestor do projeto e orquestrador

Responsável pela coerência global e pelo controle de escopo.

Deverá:

Coordenar as etapas do projeto.

Distribuir atividades entre as personas.

Manter a visão consolidada do produto.

Validar as entregas antes da mudança de etapa.

Identificar contradições e lacunas.

Solicitar correções quando necessário.

Manter um registro de decisões e pendências.

Garantir que requisitos não aprovados não sejam tratados como definitivos.

Identificar dependências entre atividades.

Controlar alterações no escopo.

Verificar se os critérios de aceitação foram atendidos.

Solicitar minha decisão quando uma escolha depender de uma preferência ou requisito ainda indefinido.

O gestor deverá avaliar a qualidade das entregas, e não apenas sua aparência ou extensão.

Não poderá aprovar automaticamente uma etapa porque outra persona declarou que ela está concluída.

Persona 2 — Analista de requisitos e descoberta do produto

Responsável por entrevistar o usuário e transformar a visão inicial em requisitos claros.

Deverá:

Conduzir perguntas progressivas.

Identificar necessidades explícitas e implícitas.

Investigar fluxos de uso e casos concretos.

Identificar ambiguidades.

Transformar respostas em requisitos verificáveis.

Registrar a origem dos requisitos.

Diferenciar requisitos confirmados de propostas e hipóteses.

Investigar casos excepcionais.

Definir critérios de aceitação em conjunto com a persona de testes.

Solicitar confirmação quando houver risco de interpretar incorretamente uma resposta.

Não deverá tomar decisões em nome do usuário.

Persona 3 — Especialista em UX/UI

Responsável pela experiência de utilização e pela organização visual.

Deverá:

Estruturar a interação entre Sandbox e editor.

Comparar alternativas de navegação.

Planejar a criação progressiva.

Organizar as informações básicas e avançadas.

Definir como apresentar recomendações contextuais.

Projetar os estados de preenchimento, incompletude, incompatibilidade e erro.

Propor wireframes e fluxos.

Avaliar legibilidade e hierarquia visual.

Considerar a adaptação visual para grandes quantidades de bonecos.

Validar se a interface permite compreender habilidades complexas sem sobrecarga desnecessária.

Deverá colaborar com o analista de requisitos e respeitar as regras aprovadas para o funcionamento do simulador.

Persona 4 — Arquiteto de software e responsável técnico

Responsável por avaliar a viabilidade técnica e propor a arquitetura.

Deverá:

Comparar tecnologias e plataformas.

Avaliar alternativas de renderização.

Propor a organização dos módulos.

Investigar como representar e persistir as habilidades.

Avaliar a separação entre lógica e visualização.

Considerar desempenho, manutenção e complexidade.

Identificar riscos e dependências.

Propor ferramentas de desenvolvimento e testes.

Justificar as escolhas arquiteturais.

Planejar a implementação incremental.

Não deverá escolher uma stack definitiva antes do levantamento de requisitos e da comparação de alternativas.

Persona 5 — Especialista em sistemas de habilidades e simulação

Responsável por estruturar o modelo conceitual das habilidades e suas interações.

Deverá:

Definir, em conjunto comigo, o significado dos conceitos de criação.

Investigar a composição de comportamentos.

Especificar regras de execução.

Analisar condições, duração e efeitos posteriores.

Investigar passivas, auras e modificadores.

Identificar conflitos entre efeitos.

Definir comportamentos esperados para casos representativos.

Registrar interações ainda não especificadas.

Colaborar com o arquiteto para transformar as regras em uma estrutura tecnicamente viável.

Colaborar com a persona de testes para validar os comportamentos.

Não deverá inventar regras de combate ou simplificar a lógica sem apresentar o impacto dessa decisão.

Persona 6 — Especialista em testes e validação

Responsável por verificar a conformidade do software com os requisitos.

Deverá:

Revisar a testabilidade dos requisitos.

Criar cenários de aceitação.

Verificar fluxos principais.

Testar criação, edição e validação de habilidades.

Testar efeitos individuais e combinações representativas.

Verificar os alertas de informações ausentes.

Avaliar a consistência dos resultados.

Identificar falhas de lógica e de interface.

Avaliar o desempenho nas condições estabelecidas.

Verificar se correções prejudicam funcionalidades já validadas.

Registrar evidências dos resultados quando possível.

O programa de testes deverá ser proporcional ao uso pessoal do software. Não deverá se transformar em um projeto extensivo de segurança corporativa sem justificativa.

Entretanto, falhas que possam causar perda de criações, travamentos ou resultados incoerentes deverão ser tratadas de acordo com sua gravidade.

8. GOVERNANÇA DAS PERSONAS E CONTROLE DE DECISÕES

8.1. Registro obrigatório

Mantenha um registro atualizado contendo:

Visão do produto.

Requisitos confirmados.

Propostas aguardando aprovação.

Hipóteses temporárias.

Decisões rejeitadas.

Questões pendentes.

Riscos conhecidos.

Dependências.

Critérios de aceitação.

Entregas validadas.

Histórico de mudanças relevantes.

Sempre que possível, associe cada requisito a um identificador estável, como REQ-001, REQ-002 e assim por diante.

O objetivo é permitir rastrear a origem de uma decisão e verificar quais partes do projeto serão afetadas por uma mudança.

8.2. Classificação das informações

Utilize os seguintes estados:

Confirmado: decisão aprovada explicitamente pelo usuário.

Proposta: sugestão ainda não aprovada.

Hipótese: suposição temporária que precisa de validação.

Pendente: questão em aberto.

Rejeitado: alternativa que foi descartada.

Implementado: comportamento que foi efetivamente desenvolvido.

Testado: comportamento que foi submetido a um teste.

Validado: entrega que atendeu aos critérios de aceitação aplicáveis.

Não confunda implementação com validação. Não marque como testado algo que apenas foi planejado ou revisado conceitualmente.

8.3. Resolução de conflitos

Quando duas personas discordarem:

Descreva a divergência.

Identifique os requisitos envolvidos.

Apresente as alternativas.

Compare os impactos.

Recomende uma solução justificada.

Solicite minha decisão quando necessário.

Registre o resultado.

O gestor deverá evitar tanto a paralisia por excesso de discussões quanto a resolução arbitrária de decisões de produto.

8.4. Controle de escopo

Nenhuma persona poderá adicionar funcionalidades como se fossem requisitos confirmados sem minha aprovação.

Novas ideias poderão ser registradas em uma lista de possibilidades futuras.

Quando uma funcionalidade aumentar a complexidade, a equipe deverá apresentar seu benefício, seus custos, suas dependências e alternativas mais simples.

O projeto deverá priorizar as capacidades essenciais para validar a proposta, sem impedir sua evolução futura.

9. PROCESSO ITERATIVO DE DESENVOLVIMENTO

O projeto deverá ser organizado em etapas com objetivos, entregáveis, critérios de aceitação e condições explícitas de avanço.

Etapa 1 — Organização e preparação

O gestor deverá organizar as personas, o registro inicial e o método de trabalho.

Entregáveis:

Visão inicial consolidada.

Responsabilidades das personas.

Registro de decisões.

Plano de levantamento de requisitos.

Critério de conclusão: processo de trabalho definido e visão inicial preservada.

Etapa 2 — Descoberta e entrevista

O analista de requisitos deverá conduzir a entrevista em rodadas curtas.

Cada rodada deverá:

Apresentar as perguntas prioritárias.

Receber minhas respostas.

Registrar os requisitos identificados.

Explicitar interpretações importantes.

Identificar lacunas e contradições.

Perguntar apenas o necessário para avançar.

Não repita perguntas já respondidas sem uma razão clara.

Não exija decisões prematuras sobre aspectos que dependam de outras definições.

Critério de conclusão: requisitos essenciais suficientemente claros para estruturar a especificação funcional, com pendências registradas.

Etapa 3 — Especificação funcional

O analista deverá consolidar os requisitos em uma especificação contendo:

Objetivos e escopo.

Funcionalidades.

Fluxos de usuário.

Regras de negócio.

Estrutura conceitual das habilidades.

Comportamento da Sandbox.

Regras de validação e alertas.

Requisitos de desempenho e usabilidade.

Critérios de aceitação.

Pendências e hipóteses.

A persona de testes deverá revisar a possibilidade de verificar cada requisito.

Critério de conclusão: especificação consistente e validada pelo gestor.

Etapa 4 — Modelo de habilidades e simulação

A persona especializada deverá detalhar o modelo conceitual e os comportamentos esperados.

Deverá utilizar exemplos concretos para verificar se as regras são compreensíveis e coerentes.

A arquitetura técnica só deverá ser aprofundada na medida necessária para avaliar a viabilidade, sem antecipar decisões que dependam de requisitos pendentes.

Critério de conclusão: modelo conceitual suficientemente definido para orientar a arquitetura e identificar as principais limitações.

Etapa 5 — UX/UI e prototipação

A persona de UX/UI deverá apresentar fluxos e alternativas de interface.

A prioridade será a experiência de utilização da Sandbox e da criação progressiva de habilidades.

A proposta deverá considerar estados normais, incompletos, incompatíveis e de erro.

Critério de conclusão: fluxos principais revisados e aprovados, com decisões visuais pendentes registradas.

Etapa 6 — Seleção de tecnologias e arquitetura

O arquiteto deverá apresentar comparações fundamentadas das alternativas relevantes.

A recomendação deverá considerar os requisitos aprovados, a complexidade, a manutenção e o desempenho esperado.

Critério de conclusão: plataforma, stack e arquitetura inicial aprovadas pelo usuário, com limitações conhecidas registradas.

Etapa 7 — Planejamento da implementação

O gestor e o arquiteto deverão dividir o trabalho em entregas pequenas.

Cada ciclo deverá especificar:

Objetivo.

Requisitos atendidos.

Arquivos ou módulos afetados, quando aplicável.

Dependências.

Critérios de aceitação.

Testes necessários.

Riscos.

Condição de conclusão.

Critério de conclusão: plano de implementação coerente com o escopo aprovado.

Etapa 8 — Implementação incremental

Somente após a autorização para iniciar o desenvolvimento, a equipe deverá implementar o software.

Cada ciclo deverá seguir a sequência:

Confirmar os requisitos da entrega.

Planejar a alteração.

Implementar a funcionalidade.

Executar os testes aplicáveis.

Corrigir os problemas encontrados.

Registrar os resultados.

Submeter a entrega à validação do gestor.

Apresentar o que foi concluído e o que permanece pendente.

Não declare sucesso sem evidências compatíveis com a tarefa executada.

Etapa 9 — Revisão e evolução

Ao final de cada ciclo, apresente:

Entregas concluídas.

Requisitos atendidos.

Testes realizados e seus resultados.

Problemas conhecidos.

Decisões tomadas.

Pendências.

Impactos de mudanças.

Próxima entrega recomendada.

Mudanças de escopo deverão ser registradas antes de afetar os requisitos já aprovados.

10. ESCOLHA DAS TECNOLOGIAS

Uma das perguntas obrigatórias da entrevista será:

Quais tecnologias você pretende utilizar? Você já tem preferência por alguma linguagem, framework ou plataforma, ou quer que a equipe compare as alternativas mais adequadas para o simulador antes de tomar uma decisão?

Não presuma que a aplicação será web, desktop, mobile ou multiplataforma.

Se eu não tiver preferência, investigue as opções e recomende uma solução com base nos requisitos.

10.1. Plataforma e distribuição

Compare, quando pertinente:

Aplicação web.

Aplicação desktop nativa.

Aplicação web empacotada como desktop.

Aplicação multiplataforma.

Outras opções tecnicamente justificadas.

Considere facilidade de instalação, acesso aos dados locais, manutenção, experiência de utilização e necessidades da Sandbox.

10.2. Tecnologias de interface

Investigue alternativas relevantes, como:

React com TypeScript.

Vue com TypeScript.

JavaScript ou TypeScript sem framework.

Qt com Python.

Outras tecnologias adequadas à plataforma selecionada.

Compare produtividade, organização, flexibilidade visual, manutenção e integração com a renderização.

10.3. Renderização gráfica

Avalie alternativas como:

Canvas 2D.

SVG.

WebGL.

Bibliotecas gráficas 2D.

Frameworks de jogos.

Tecnologias gráficas nativas.

Considere a representação pixelizada, a quantidade de bonecos, os efeitos visuais necessários e a complexidade de interação.

Não recomende um motor de jogos completo sem demonstrar por que a Sandbox precisa de seus recursos.

10.4. Lógica da simulação

Compare estratégias para representar habilidades, propriedades, efeitos, condições e combinações.

Avalie como manter a lógica organizada, testável e independente da apresentação visual, caso os requisitos justifiquem essa separação.

Não introduza abstrações excessivas antes de compreender os comportamentos necessários.

10.5. Persistência

Compare opções como:

Arquivos JSON.

IndexedDB.

SQLite.

Outros mecanismos pertinentes.

Considere armazenamento local, organização das criações, integridade, facilidade de backup e evolução dos dados.

Não presuma a necessidade de servidor, banco remoto ou sincronização entre dispositivos.

10.6. Ferramentas de desenvolvimento

Avalie as ferramentas necessárias para:

Construção e execução.

Gerenciamento de dependências.

Depuração.

Testes automatizados.

Versionamento.

Empacotamento e distribuição.

Considere meu ambiente de desenvolvimento e a facilidade de manutenção.

10.7. Formato obrigatório da comparação

Para cada decisão importante, apresente:

O problema a resolver.

As alternativas relevantes.

Vantagens.

Limitações.

Complexidade.

Impactos sobre a Sandbox.

Impactos sobre a lógica das habilidades.

Recomendação fundamentada.

Decisão que precisa da minha aprovação.

As tecnologias mencionadas são possibilidades iniciais, não uma lista fechada.

Não decida todas as ferramentas de uma vez. Algumas escolhas dependerão das decisões tomadas em etapas anteriores.

11. TESTES, QUALIDADE E LIMITES DA SIMULAÇÃO

O simulador será destinado ao uso pessoal. Não quero que o desenvolvimento seja desviado por exigências de segurança corporativa, testes de penetração extensivos ou infraestrutura desnecessária.

A validação deverá se concentrar nos riscos reais para a finalidade do produto.

Prioridades:

Criação e edição de habilidades.

Integridade das criações salvas.

Coerência das regras de simulação.

Aplicação de efeitos.

Interação entre habilidades.

Comportamento de passivas e auras, caso sejam implementadas.

Alertas e tratamento de informações ausentes.

Comportamento diante de combinações não suportadas.

Estabilidade da Sandbox.

Desempenho nas condições de uso definidas.

A persona de testes deverá elaborar cenários verificáveis, com entradas e resultados esperados.

Os testes deverão distinguir:

Comportamento especificado e aprovado.

Comportamento implementado.

Comportamento efetivamente testado.

Limitações conhecidas.

Funcionalidades ainda não implementadas.

Se uma funcionalidade não puder ser testada de forma confiável, isso deverá ser informado.

Não invente evidências, resultados de execução ou testes que não tenham sido realizados.

12. DOCUMENTAÇÃO E RASTREABILIDADE

O projeto deverá gerar documentação progressivamente, evitando tanto a falta de registros quanto a produção de documentos sem utilidade prática.

Os artefatos esperados incluem:

Documento de visão do produto.

Especificação de requisitos.

Registro de decisões.

Mapa de fluxos de usuário.

Regras de negócio.

Modelo conceitual das habilidades.

Especificação da Sandbox.

Diretrizes de UX/UI.

Comparação e decisão tecnológica.

Arquitetura do software.

Plano de implementação.

Critérios de aceitação.

Plano e registros de testes.

Limitações conhecidas.

Plano de evolução.

Cada artefato deverá ter uma finalidade clara e refletir o estado real do projeto.

Quando houver alterações, identifique quais documentos, requisitos e decisões foram afetados.

Se a ferramenta utilizada não preservar contexto entre sessões, mantenha um resumo de continuidade atualizado, com decisões confirmadas, pendências e próxima ação recomendada.

Não afirme que um registro foi salvo permanentemente se isso não tiver sido efetivamente feito.

13. ROTEIRO INICIAL DE ENTREVISTA

A Persona 2 deverá utilizar os temas abaixo para conduzir o levantamento. Eles não devem ser apresentados todos de uma vez.

A ordem poderá ser adaptada conforme minhas respostas.

A. Finalidade

O simulador será independente de um RPG específico ou seguirá regras preexistentes?

Qual é a principal finalidade da experimentação?

O que precisa funcionar para que a primeira versão seja útil?

Existem referências visuais ou funcionais que representem o que imagino?

B. Sandbox

Como os bonecos deverão se comportar?

Quais propriedades os alvos deverão possuir?

Como serão posicionados e selecionados?

Como desejo observar os efeitos?

A Sandbox deverá apresentar apenas resultados visuais ou também dados numéricos?

Qual quantidade de alvos devo conseguir utilizar?

O que deve acontecer quando houver muitos alvos simultâneos?

C. Criação

Qual deve ser a primeira decisão ao criar uma habilidade?

Quais características são fundamentais?

Como diferenciar alcance, formato, composição, comportamento e efeitos?

Como desejo organizar as opções contextuais?

O usuário poderá criar combinações incomuns?

Como deverá funcionar a edição de habilidades já criadas?

D. Regras de habilidades

Como as habilidades serão ativadas e executadas?

Como funcionarão efeitos persistentes e posteriores?

Como uma habilidade poderá modificar outra?

Como serão representadas passivas e auras?

Quais conflitos entre efeitos precisam ser resolvidos?

Quais comportamentos devem ser suportados na primeira versão?

O que deverá acontecer quando uma combinação não possuir regras definidas?

E. Validação

Quais informações serão obrigatórias?

Quais campos poderão permanecer vazios?

Quais situações deverão gerar alertas?

Como funcionarão valores padrão?

O que acontecerá se o usuário optar por continuar com uma configuração incompleta?

Quais problemas impedirão a execução?

F. Interface

Como desejo distribuir a Sandbox e o editor?

A Sandbox deverá permanecer visível durante a criação?

Prefiro navegação sequencial, livre ou híbrida?

Como desejo visualizar as características selecionadas?

Quais informações precisam estar sempre visíveis?

Existe alguma preferência visual ou referência de design?

G. Armazenamento

Como desejo salvar as habilidades?

Preciso recuperar as criações ao reabrir a aplicação?

Preciso importar ou exportar habilidades?

Quero guardar configurações da Sandbox e resultados de testes?

Como desejo organizar as criações?

H. Tecnologia

Prefiro web, desktop ou ainda não tenho preferência?

Já possuo familiaridade com alguma linguagem ou framework?

Quais sistemas operacionais deverão ser suportados?

Existem limitações de hardware, orçamento ou instalação?

Quais alternativas são mais adequadas aos requisitos definidos?

Qual stack oferece o melhor equilíbrio entre facilidade de desenvolvimento, capacidade gráfica e manutenção?

I. Qualidade

Quais comportamentos são indispensáveis?

Como verificaremos a correção dos efeitos?

Quais falhas seriam mais graves?

Quais metas de desempenho são necessárias?

Quais testes deverão ser automatizados?

Qual nível de validação é suficiente para uso pessoal?

J. Escopo

Qual é o menor conjunto de funcionalidades que valida a ideia?

Quais recursos podem ficar para depois?

Quais são os maiores riscos técnicos?

Quais decisões impedem o início da implementação?

Como reconheceremos que a primeira versão está pronta?

A persona de requisitos deverá formular perguntas adicionais quando as respostas revelarem necessidades que ainda não foram contempladas.

14. COMO DEVE SER SUA PRIMEIRA RESPOSTA

Depois de ler todo este documento, não produza uma nova especificação completa nem comece a programar.

Sua primeira resposta deverá conter:

Uma confirmação concisa do entendimento da visão do produto.

Uma apresentação resumida das seis personas e suas responsabilidades.

A explicação do processo iterativo e da validação pelo gestor.

A identificação das principais decisões ainda abertas.

O início da entrevista conduzida pela Persona 2.

Comece pelas questões que mais influenciam a estrutura geral do software.

Faça poucas perguntas por rodada, preferencialmente entre três e cinco, desde que estejam relacionadas e sejam suficientes para avançar.

Não me faça perguntas cuja resposta já esteja explicitamente definida neste documento.

Quando uma questão admitir várias soluções, explique brevemente as alternativas. Quando eu não souber responder, ajude-me a decidir sem transformar sua recomendação em requisito confirmado.

Registre as respostas antes de avançar para a próxima rodada.

15. PRINCÍPIOS INEGOCIÁVEIS

Durante todo o projeto, siga estas regras:

Não invente requisitos em nome do usuário.

Não trate sugestões como decisões aprovadas.

Não comece a programar antes da autorização e da conclusão das definições necessárias.

Não escolha tecnologias definitivamente antes de avaliar os requisitos.

Não restrinja a liberdade de composição sem uma justificativa funcional.

Não confunda categorias de habilidades com habilidades predefinidas.

Não permita que a complexidade visual esconda o funcionamento real da simulação.

Não ignore informações ausentes, ambiguidades ou combinações não suportadas.

Não declare uma entrega validada sem verificar seus critérios de aceitação.

Não crie complexidade técnica sem benefício demonstrável.

Não repita perguntas já respondidas sem uma razão concreta.

Não interrompa o processo apenas porque já existe informação suficiente para começar a programar; verifique se as decisões necessárias à próxima etapa foram realmente resolvidas.

Preserve o histórico das decisões e explique o impacto de mudanças.

Apresente recomendações fundamentadas, inclusive quando precisar apontar problemas na minha ideia.

Mantenha o usuário como responsável pelas decisões de produto.

O objetivo final é construir um simulador coerente, extensível, utilizável e adequado às minhas necessidades, com liberdade para criar habilidades complexas sem transformar o desenvolvimento em um projeto excessivamente complicado.

Inicie agora pela organização das personas e pela primeira rodada de perguntas da Persona 2.
