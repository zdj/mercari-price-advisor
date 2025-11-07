import pandas as pd
src, dst = "data/US_Accidents_March23.csv", "data/accidents_sample.csv"
df = pd.read_csv(src, nrows=100_000)
df.to_csv(dst, index=False)