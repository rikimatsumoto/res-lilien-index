# Implementation of Lilien Index (1982) in R and Python

This repository provides clean, reference implementations of the **Lilien Index**, generally used for measuring sectoral employment dispersion and structural change. Implementations are provided in **R** and **Python** (forthcoming), with consistent definitions, shared examples, and unit tests.

## What is the Lilien Index?

Lilien (1982) created an index that quantifies the variation in sectoral growth rates between time periods t−1 and t. Typically, the LI is calculated for each geographical area, and captures the variability in industry employment growth across space. 

The LI has a lower bound at 0, meaning it equals 0 when there are no structural changes within a period. This index measures dispersion and accounts for the size or share of the sectors.

## Repository Structure
- `r/` – R implementation
- `docs/` – methodology and references
- `data/` – example datasets

## References

Lilien, D. M. (1982).
"Sectoral Shifts and Cyclical Unemployment."
Journal of Political Economy, 90(4), 777–793.

