# This file was generated by PredictMD version 0.34.0-DEV, code name Unstable Angina
# For help, please visit https://predictmd.net

import PredictMDExtra
PredictMDExtra.import_all()

import PredictMD
PredictMD.import_all()





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

### Begin model comparison code

Kernel = LIBSVM.Kernel

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

smoted_training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "smoted_training_labels_df.csv",
    )
smoted_training_features_df = DataFrames.DataFrame(
    FileIO.load(
        smoted_training_features_df_filename;
        type_detect_rows = 100,
        )
    )
smoted_training_labels_df = DataFrames.DataFrame(
    FileIO.load(
        smoted_training_labels_df_filename;
        type_detect_rows = 100,
        )
    )

logistic_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "logistic_classifier.jld2",
    )
random_forest_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "random_forest_classifier.jld2",
    )
c_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "c_svc_svm_classifier.jld2",
    )
nu_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "nu_svc_svm_classifier.jld2",
    )
knet_mlp_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "knet_mlp_classifier.jld2",
    )



logistic_classifier =
    PredictMD.load_model(logistic_classifier_filename)
random_forest_classifier =
    PredictMD.load_model(random_forest_classifier_filename)
c_svc_svm_classifier =
    PredictMD.load_model(c_svc_svm_classifier_filename)
nu_svc_svm_classifier =
    PredictMD.load_model(nu_svc_svm_classifier_filename)
knet_mlp_classifier =
    PredictMD.load_model(knet_mlp_classifier_filename)

PredictMD.parse_functions!(logistic_classifier)
PredictMD.parse_functions!(random_forest_classifier)
PredictMD.parse_functions!(c_svc_svm_classifier)
PredictMD.parse_functions!(nu_svc_svm_classifier)
PredictMD.parse_functions!(knet_mlp_classifier)



all_models = PredictMD.AbstractFittable[
    logistic_classifier,
    random_forest_classifier,
    c_svc_svm_classifier,
    nu_svc_svm_classifier,
    knet_mlp_classifier,
    ]

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"

single_label_levels = [negative_class, positive_class]

categorical_label_names = Symbol[single_label_name]
continuous_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

println(
    string(
        "Single label binary classification metrics, training set, ",
        "fix sensitivity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    string(
        "Single label binary classification metrics, training set, ",
        "fix specificity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        specificity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    string(
        "Single label binary classification metrics, training set, ",
        "maximize F1 score",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        maximize = :f1score,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    string(
        "Single label binary classification metrics, training set, ",
        "maximize Cohen's kappa",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        maximize = :cohen_kappa,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    string(
        "Single label binary classification metrics, testing set, ",
        "fix sensitivity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )



println(
    string(
        "Single label binary classification metrics, testing set, ",
        "fix specificity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        specificity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    string(
        "Single label binary classification metrics, testing set, ",
        "maximize F1 score",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        maximize = :f1score,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    string(
        "Single label binary classification metrics, testing set, ",
        "maximize Cohen's kappa",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        maximize = :cohen_kappa,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

rocplottesting = PredictMD.plotroccurve(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );



display(rocplottesting)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "rocplottesting.pdf",
        ),
    rocplottesting,
    )

prplottesting = PredictMD.plotprcurve(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );



display(prplottesting)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "prplottesting.pdf",
        ),
    prplottesting,
    )

### End model comparison code



# This file was generated by PredictMD version 0.34.0-DEV, code name Unstable Angina
# For help, please visit https://predictmd.net

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

