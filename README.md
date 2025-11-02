## Dataset

This project uses the US Accidents (2016–2023) dataset (Kaggle). 

The app predicts the probability that an incident’s conditions (time, place, weather/road context) correspond to a serious accident (Severity ≥ 3) and surfaces nearby historical comparables with explainable factors (SHAP) to support the risk estimate.

## Milestones

### M0: Initial project setup



### M1.2: 🧩 Dataset Setup (Obtain & Stage the US Accidents Dataset)

Milestone 1.2 Summary — Obtain & Stage the US Accidents Dataset

During this milestone, we successfully acquired, verified, and staged the US Accidents (2016–2023) dataset to serve as the foundation for model development. We authenticated the Kaggle CLI using an API token and downloaded the latest dataset release, then extracted and explored its structure to confirm data integrity and completeness. Because the full dataset is very large, we created a manageable 100,000-row sample to support local experimentation and faster iteration while maintaining representative distributions of accident severity and feature diversity.

After downloading and sampling the data, we performed basic quality checks to confirm column counts, row totals, and the overall severity distribution across classes. This validation ensured that the sample remains statistically meaningful and suitable for model training and feature engineering. The staged dataset now resides in the data/ directory, with large files excluded from version control and placeholders maintained for reproducibility. With the dataset ready and verified, the project is now positioned to move forward into data cleaning and preprocessing in the next milestone.