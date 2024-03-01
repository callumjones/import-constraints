# Data and Code for "Import Constraints"

by Diego Comin, Robert C. Johnson, and Callum Jones
January, 2024

## Software Requirements

- Matlab 2023b, with the Optimization Toolbox
- Dynare 5.5-arm64

## Files

- `code/model.mod`: Dynare model file for version of the model in which trade costs adjust when the import constraint binds.
- `code/model_unpriced.mod`: Dynare model file for the version of the mode in which trade costs do not adjust when the constraint binds.
- `code/solve_ss.m`: Matlab function used to compute the model's steady-state.
- `code/run.m`: main Matlab script to run model codes and produce figures.

## Reproduce Figures

To produce all figures, execute the script `code/run.m`.
