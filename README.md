# Desafio Prático de Dados/IA — Empreendedorismo em Santa Catarina

Solução desenvolvida para o **Desafio Prático de Dados/IA** do Programa SCTEC (Edital IA para DEVs), com abordagem de **Análise Exploratória de Dados (AED)**.

## Descrição da solução

O projeto realiza tratamento e análise de dados relacionados ao empreendedorismo no estado de Santa Catarina. Foram implementadas as etapas de **carregamento**, **limpeza** (valores ausentes e inconsistentes), **organização** e **análise** dos dados, com geração de tabelas, métricas e visualizações (gráficos de barras, histograma, boxplot e heatmap) para interpretação dos resultados. A solução utiliza um conjunto de dados simulado, plausível e coerente com o tema, conforme permitido pelo edital quando não há base pública adequada disponível em formato pronto.

## Origem do conjunto de dados

Foi utilizado um **conjunto de dados simulado** (mockado), gerado pelo script `data/gerar_dados.py`, representando de forma coerente indicadores de empreendedorismo em Santa Catarina. O desenho dos dados foi inspirado em estatísticas e estruturas típicas de bases públicas (IBGE, SEBRAE, JUCESC). Os municípios e regiões contemplados correspondem a cidades reais do estado; os setores de atividade e as variáveis (quantidade de empresas, MEI, empregos formais, faturamento médio, sobrevivência) refletem cenários plausíveis para análise. A origem e a natureza dos dados estão claramente informadas nesta documentação. Para reproduzir o dataset, execute: `python data/gerar_dados.py` a partir da raiz do projeto.

## Tecnologias empregadas

- **Python 3.10+**
- **pandas**: manipulação e análise de dados
- **NumPy**: operações numéricas
- **Matplotlib** e **Seaborn**: visualizações
- **Jupyter**: notebook interativo para execução da análise

## Estrutura do projeto

```
desafio-dados-ia-sctec/
├── README.md
├── requirements.txt
├── data/
│   ├── empreendedorismo_sc.csv   # Dataset utilizado na análise
│   └── gerar_dados.py           # Script para gerar o dataset
├── notebooks/
│   └── analise_empreendedorismo_sc.ipynb  # Notebook com a AED completa
```

## Instruções para execução

1. **Clone o repositório** (ou acesse a pasta do projeto).

2. **Crie um ambiente virtual** (recomendado):
   ```bash
   python -m venv venv
   venv\Scripts\activate   # Windows
   ```

3. **Instale as dependências**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Gere o dataset** (se o arquivo `data/empreendedorismo_sc.csv` ainda não existir):
   ```bash
   python data/gerar_dados.py
   ```

5. **Execute o notebook de análise**:
   - Abra `notebooks/analise_empreendedorismo_sc.ipynb` no Jupyter (ou VS Code/Cursor).
   - Execute todas as células em ordem (Run All). O notebook carrega os dados, aplica o tratamento, organiza as informações e gera as tabelas e gráficos da análise exploratória.

Os resultados (tabelas e figuras) são exibidos diretamente no notebook. Não é necessária configuração adicional.

## Vídeo pitch

Vídeo pitch: [link]

---

*Projeto desenvolvido no âmbito do processo seletivo do Programa SCTEC — Trilha IA para DEVs.*
