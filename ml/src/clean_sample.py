from data_prep import load_df, clean

import argparse
if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", default="data/accidents_sample.csv")
    ap.add_argument("--dst", default="data/accidents_cleaned.parquet")
    args = ap.parse_args()
    df = clean(load_df(args.src))
    df.to_parquet(args.dst, index=False)
    print(f"✅ Saved cleaned dataset to {args.dst}")