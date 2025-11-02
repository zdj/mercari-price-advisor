## Dataset

This project uses the US Accidents (2016–2023) dataset (Kaggle). 

The app predicts the probability that an incident’s conditions (time, place, weather/road context) correspond to a serious accident (Severity ≥ 3) and surfaces nearby historical comparables with explainable factors (SHAP) to support the risk estimate.

## Milestones

### M0.0: Initial project setup

### M1.0: Project Initialization & Repository Setup

In this milestone, we established the foundation for the US Accident Risk Advisor project. The primary goal was to initialize a well-structured repository and configure the development environment to support a modern, reproducible ML workflow. We created the core directory layout (src/, data/, models/, notebooks/, scripts/, tests/), set up .gitignore rules for large files and local artifacts, and documented initial project metadata. We also drafted the high-level project vision — an interactive system for predicting accident risk using real-world traffic data — and captured that in the README.md. This stage ensured that the project started with a clean, maintainable structure aligned with best practices for collaborative ML and API development.

### M1.1: Environment Bootstrapping & Dependency Management

In this milestone, we built a consistent, cross-platform development environment for both machine learning and backend API work. Using the uv package manager, we created a clean Python 3.12 virtual environment inside the ml/ directory and installed the essential runtime dependencies — including FastAPI, pandas, scikit-learn, LightGBM, NumPy, and related libraries. We also added optional support for SHAP-based explainability and verified all core imports to ensure compatibility with macOS and Apple Silicon. To make setup reproducible for all team members, we added reusable scripts (rebuild_env.sh and rebuild_env.fish) to automate environment creation, package installation, and dependency freezing. By the end of M1.1, the environment was fully reproducible and ready for data ingestion and model experimentation.

### M1.2: Dataset Setup (Obtain & Stage the US Accidents Dataset)

During this milestone, we successfully acquired, verified, and staged the US Accidents (2016–2023) dataset to serve as the foundation for model development. We authenticated the Kaggle CLI using an API token and downloaded the latest dataset release, then extracted and explored its structure to confirm data integrity and completeness. Because the full dataset is very large, we created a manageable 100,000-row sample to support local experimentation and faster iteration while maintaining representative distributions of accident severity and feature diversity.

After downloading and sampling the data, we performed basic quality checks to confirm column counts, row totals, and the overall severity distribution across classes. This validation ensured that the sample remains statistically meaningful and suitable for model training and feature engineering. The staged dataset now resides in the data/ directory, with large files excluded from version control and placeholders maintained for reproducibility. With the dataset ready and verified, the project is now positioned to move forward into data cleaning and preprocessing in the next milestone.