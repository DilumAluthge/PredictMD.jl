# This file was generated by PredictMD version 0.34.14
# For help, please visit https://predictmd.net

using PredictMDExtra
PredictMDExtra.import_all()

using PredictMD
PredictMD.import_all()

using CSVFiles
using CategoricalArrays
using DataFrames
using DecisionTree
using Distributions
using FileIO
using GLM
using IterTools
using Knet
using LIBSVM
using LinearAlgebra
using PredictMD
using PredictMDAPI
using PredictMDExtra
using RDatasets
using Random
using StatsModels
using Test
using Unitful

const Schema = StatsModels.Schema



### Begin project-specific settings

DIRECTORY_CONTAINING_THIS_FILE = @__DIR__
PROJECT_DIRECTORY = dirname(
    joinpath(splitpath(DIRECTORY_CONTAINING_THIS_FILE)...)
    )
PROJECT_OUTPUT_DIRECTORY = joinpath(
    PROJECT_DIRECTORY,
    "output",
    )
mkpath(PROJECT_OUTPUT_DIRECTORY)
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "data"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "models"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "plots"))



### End project-specific settings

### Begin model output code

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_labels_df.csv",
    )
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
trainingandtuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )
testing_features_df = DataFrames.DataFrame(
    FileIO.load(
        testing_features_df_filename;
        type_detect_rows = 100,
        )
    )
testing_labels_df = DataFrames.DataFrame(
    FileIO.load(
        testing_labels_df_filename;
        type_detect_rows = 100,
        )
    )
training_features_df = DataFrames.DataFrame(
    FileIO.load(
        training_features_df_filename;
        type_detect_rows = 100,
        )
    )
training_labels_df = DataFrames.DataFrame(
    FileIO.load(
        training_labels_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )

linear_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "linear_regression.jld2",
    )
random_forest_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "random_forest_regression.jld2",
    )
knet_mlp_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "knet_mlp_regression.jld2",
    )



linear_regression =
    PredictMD.load_model(linear_regression_filename)
random_forest_regression =
    PredictMD.load_model(random_forest_regression_filename)
knet_mlp_regression =
    PredictMD.load_model(knet_mlp_regression_filename)

PredictMD.parse_functions!(linear_regression)
PredictMD.parse_functions!(random_forest_regression)
PredictMD.parse_functions!(knet_mlp_regression)



PredictMD.predict(linear_regression,training_features_df,)
PredictMD.predict(random_forest_regression,training_features_df,)
PredictMD.predict(knet_mlp_regression,training_features_df,)

PredictMD.predict(linear_regression,testing_features_df,)
PredictMD.predict(random_forest_regression,testing_features_df,)
PredictMD.predict(knet_mlp_regression,testing_features_df,)

### End model output code



# This file was generated by PredictMD version 0.34.14
# For help, please visit https://predictmd.net

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

