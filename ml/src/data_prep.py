# src/data_prep.py
"""
Data cleaning and preprocessing for the US Accident Risk Advisor project.

This module:
- Loads and inspects raw CSV data.
- Cleans missing and invalid values.
- Extracts time-based features (hour, day of week).
- Prepares numeric and categorical columns for model training.
"""

import pandas as pd
import numpy as np

# Core feature groups
NUM_COLS = [
    "Distance(mi)", "Temperature(F)", "Humidity(%)", "Pressure(in)",
    "Visibility(mi)", "Wind_Speed(mph)", "Precipitation(in)",
    "Start_Lat", "Start_Lng"
]

CAT_COLS = [
    "State", "Weather_Condition", "Sunrise_Sunset",
    "Amenity", "Bump", "Crossing", "Give_Way", "Junction",
    "No_Exit", "Railway", "Roundabout", "Station", "Stop",
    "Traffic_Calming", "Traffic_Signal", "Turning_Loop"
]

def load_df(path: str) -> pd.DataFrame:
    """Load raw CSV data with basic type inference."""
    df = pd.read_csv(path)
    print(f"✅ Loaded {len(df):,} rows, {len(df.columns)} columns from {path}")
    return df

def clean(df: pd.DataFrame) -> pd.DataFrame:
    """Perform light cleaning and feature engineering."""
    # Convert timestamps
    df["Start_Time"] = pd.to_datetime(df["Start_Time"], errors="coerce")

    # Drop rows missing critical coordinates or timestamps
    df = df.dropna(subset=["Start_Lat", "Start_Lng", "Start_Time"]).copy()

    # Derive time-based features
    df["hour"] = df["Start_Time"].dt.hour
    df["dow"] = df["Start_Time"].dt.dayofweek

    # Create binary target: 1 if Severity >= 3
    df["y"] = (df["Severity"] >= 3).astype(int)

    # Clean numeric columns
    for c in NUM_COLS:
        if c in df:
            df[c] = pd.to_numeric(df[c], errors="coerce").fillna(df[c].median())

    # Clean categorical columns
    for c in CAT_COLS:
        if c in df:
            df[c] = df[c].astype(str).replace({"nan": "unknown"}).fillna("unknown")

    print(f"✅ Cleaned dataset: {len(df):,} rows remain after dropping missing coordinates")
    return df

def select_xy(df: pd.DataFrame):
    """Select feature and target matrices."""
    features = [c for c in (NUM_COLS + CAT_COLS + ["hour", "dow"]) if c in df.columns]
    X = df[features].copy()
    y = df["y"].values
    return X, y, features