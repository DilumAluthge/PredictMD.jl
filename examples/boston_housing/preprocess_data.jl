srand(999)

import CSV
import DataFrames
import GZip
import PredictMD
import StatsBase

df = CSV.read(
    GZip.gzopen(
        joinpath(
            Pkg.dir("RDatasets"),
            "data",
            "MASS",
            "Boston.csv.gz",
            ),
        ),
    DataFrames.DataFrame,
    )

DataFrames.dropmissing!(df)

PredictMD.shuffle_rows!(df)

categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
    :Crim,
    :Zn,
    :Indus,
    :Chas,
    :NOx,
    :Rm,
    :Age,
    :Dis,
    :Rad,
    :Tax,
    :PTRatio,
    :Black,
    :LStat,
    ]
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)

singlelabelname = :MedV
labelnames = [singlelabelname]

features_df = df[featurenames]
labels_df = df[labelnames]

DataFrames.describe(labels_df[singlelabelname])

trainingandvalidation_features_df,
    trainingandvalidation_labels_df,
    testing_features_df,
    testing_labels_df = PredictMD.split_data(
        features_df,
        labels_df,
        0.75, # 75% training/validation, 25% testing
        )
training_features_df,
    training_labels_df,
    validation_features_df,
    validation_labels_df = PredictMD.split_data(
        trainingandvalidation_features_df,
        trainingandvalidation_labels_df,
        2/3, # 2/3 of 75% = 50% training, 1/3 of 75% = 25% validation
        )

ENV["trainingandvalidation_features_df_filename"] = string(
    tempname(),
    "_trainingandvalidation_features_df.csv",
    )
ENV["trainingandvalidation_labels_df_filename"] = string(
    tempname(),
    "_trainingandvalidation_labels_df.csv",
    )
ENV["testing_features_df_filename"] = string(
    tempname(),
    "_testing_features_df.csv",
    )
ENV["testing_labels_df_filename"] = string(
    tempname(),
    "_.testing_labels_dfcsv",
    )
ENV["training_features_df_filename"] = string(
    tempname(),
    "_training_features_df.csv",
    )
ENV["training_labels_df_filename"] = string(
    tempname(),
    "_training_labels_df.csv",
    )
ENV["validation_features_df_filename"] = string(
    tempname(),
    "_validation_features_df.csv",
    )
ENV["validation_labels_df_filename"] = string(
    tempname(),
    "_validation_labels_df.csv",
    )
trainingandvalidation_features_df_filename =
    ENV["trainingandvalidation_features_df_filename"]
trainingandvalidation_labels_df_filename =
    ENV["trainingandvalidation_labels_df_filename"]
testing_features_df_filename =
    ENV["testing_features_df_filename"]
testing_labels_df_filename =
    ENV["testing_labels_df_filename"]
training_features_df_filename =
    ENV["training_features_df_filename"]
training_labels_df_filename =
    ENV["training_labels_df_filename"]
validation_features_df_filename =
    ENV["validation_features_df_filename"]
validation_labels_df_filename =
    ENV["validation_labels_df_filename"]
CSV.write(
    trainingandvalidation_features_df_filename,
    trainingandvalidation_features_df,
    )
CSV.write(
    trainingandvalidation_labels_df_filename,
    trainingandvalidation_labels_df,
    )
CSV.write(
    testing_features_df_filename,
    testing_features_df,
    )
CSV.write(
    testing_labels_df_filename,
    testing_labels_df,
    )
CSV.write(
    training_features_df_filename,
    training_features_df,
    )
CSV.write(
    training_labels_df_filename,
    training_labels_df,
    )
CSV.write(
    validation_features_df_filename,
    validation_features_df,
    )
CSV.write(
    validation_labels_df_filename,
    validation_labels_df,
    )
