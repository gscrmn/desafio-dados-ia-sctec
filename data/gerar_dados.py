"""
Script para geração do conjunto de dados simulado sobre empreendedorismo em SC.
Executar uma vez para gerar data/empreendedorismo_sc.csv.
Dados plausíveis inspirados em indicadores públicos (IBGE, SEBRAE, JUCESC).
"""

import pandas as pd
import numpy as np
from pathlib import Path

np.random.seed(42)

MUNICIPIOS_SC = [
    "Florianópolis", "Joinville", "Blumenau", "São José", "Criciúma",
    "Chapecó", "Itajaí", "Jaraguá do Sul", "Lages", "Palhoça",
    "Balneário Camboriú", "Brusque", "Tubarão", "São Bento do Sul", "Concórdia",
    "Rio do Sul", "Curitibanos", "Navegantes", "Araranguá", "Caçador",
]

SETORES = [
    "Comércio varejista", "Serviços de alimentação", "Construção civil",
    "Tecnologia da informação", "Indústria de confecções", "Serviços pessoais",
    "Transporte e logística", "Saúde", "Educação", "Agricultura e pecuária",
]

# Gera ~500 registros com variação realista
n = 520
df = pd.DataFrame({
    "municipio": np.random.choice(MUNICIPIOS_SC, n),
    "setor": np.random.choice(SETORES, n),
    "ano_abertura": np.random.randint(2018, 2026, n),
    "quantidade_empresas": np.random.randint(1, 50, n),
    "mei": np.random.choice([True, False], n, p=[0.6, 0.4]),
    "empregos_formais": np.random.randint(0, 200, n),
})

# Faturamento médio (em mil R$) - alguns ausentes para exercício de limpeza
faturamento = np.random.exponential(50, n).round(2)
faturamento[np.random.choice(n, 35, replace=False)] = np.nan
df["faturamento_medio_mil_reais"] = faturamento

# Taxa de sobrevivência (1 ano) - percentual simulado
df["sobrevivencia_1_ano"] = (np.random.beta(8, 2, n) * 100).round(1)
df.loc[np.random.choice(n, 28, replace=False), "sobrevivencia_1_ano"] = np.nan

# Região (Grande Florianópolis, Norte, Sul, Oeste, Serra)
REGIOES = {
    "Florianópolis": "Grande Florianópolis", "São José": "Grande Florianópolis",
    "Palhoça": "Grande Florianópolis", "Joinville": "Norte", "Jaraguá do Sul": "Norte",
    "São Bento do Sul": "Norte", "Blumenau": "Vale do Itajaí", "Itajaí": "Vale do Itajaí",
    "Brusque": "Vale do Itajaí", "Navegantes": "Vale do Itajaí", "Rio do Sul": "Vale do Itajaí",
    "Criciúma": "Sul", "Tubarão": "Sul", "Araranguá": "Sul",
    "Chapecó": "Oeste", "Concórdia": "Oeste", "Lages": "Serra", "Curitibanos": "Serra",
    "Balneário Camboriú": "Vale do Itajaí", "Caçador": "Oeste",
}
df["regiao"] = df["municipio"].map(REGIOES)

# Alguns valores inconsistentes propositalmente (para tratamento na AED)
df.loc[df.sample(15).index, "empregos_formais"] = -1
df.loc[df.sample(10).index, "quantidade_empresas"] = 0

out_path = Path(__file__).parent / "empreendedorismo_sc.csv"
df.to_csv(out_path, index=False, encoding="utf-8-sig")
print(f"Dataset gerado: {out_path} ({len(df)} registros)")
