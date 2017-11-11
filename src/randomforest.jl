using DecisionTree

struct SingleLabelBinaryRandomForestClassifier <:
        AbstractSingleLabelBinaryClassifier
    blobs::T where T <: Associative
end

const BinaryRandomForest = SingleLabelBinaryRandomForestClassifier

function SingleLabelBinaryRandomForestClassifier(
        dataset::AbstractHoldoutTabularDataset,
        label_variable::Symbol;
        classes::StatsBase.IntegerVector = [0, 1],
        nsubfeatures::Integer = 2,
        ntrees::Integer = 20,
        )

    blobs = Dict{Symbol, Any}()

    hyperparameters = Dict{Symbol, Any}()
    hyperparameters[:nsubfeatures] = nsubfeatures
    hyperparameters[:ntrees] = ntrees
    blobs[:hyperparameters] = hyperparameters

    feature_variables = dataset.blobs[:feature_variables]

    if !hastraining(dataset)
        error("dataset has no training data")
    end
    blobs[:numtraining] = numtraining(dataset)
    data_training_features, recordidlist_training = getdata(
        dataset;
        training=true,
        features=true,
        features_format=:matrix,
        )
    data_training_labels = getdata(
        dataset;
        single_label = true,
        label_variable = label_variable,
        label_type = :integer,
        recordidlist = recordidlist_training,
        )
    @assert(typeof(data_training_labels) <: DataFrame)
    data_training_labels = convert(Array, data_training_labels)
    @assert(typeof(data_training_labels) <: AbstractMatrix)
    @assert(size(data_training_labels,2) == 1)
    data_training_labels = data_training_labels[:,1]
    blobs[:true_labels_training] = data_training_labels
    internal_model = build_forest(
        data_training_labels,
        data_training_features,
        nsubfeatures,
        ntrees,
        )
    blobs[:internal_model] = internal_model

    predicted_labels_training = apply_forest(
        internal_model,
        data_training_features,
        )
    blobs[:predicted_labels_training] = Int.(predicted_labels_training)
    predicted_proba_training_twocols = apply_forest_proba(
        internal_model,
        data_training_features,
        classes,
        )
    blobs[:predicted_proba_training_twocols] =
        predicted_proba_training_twocols
    predicted_proba_training_onecol =
        binaryproba_twocolstoonecol(predicted_proba_training_twocols)
    blobs[:predicted_proba_training_onecol] =
        predicted_proba_training_onecol
    predicted_proba_training = predicted_proba_training_onecol
    blobs[:predicted_proba_training] = predicted_proba_training


    if hasvalidation(dataset)
        blobs[:numvalidation] = numtraining(dataset)
        data_validation_features, recordidlist_validation = getdata(
            dataset;
            validation=true,
            features=true,
            features_format=:matrix,
            )
        data_validation_labels = getdata(
            dataset;
            single_label = true,
            label_variable = label_variable,
            label_type = :integer,
            recordidlist = recordidlist_validation,
            )
        @assert(typeof(data_validation_labels) <: DataFrame)
        data_validation_labels = convert(Array, data_validation_labels)
        @assert(typeof(data_validation_labels) <: AbstractMatrix)
        @assert(size(data_validation_labels,2) == 1)
        data_validation_labels = data_validation_labels[:,1]
        blobs[:true_labels_validation] = data_validation_labels

        predicted_labels_validation = apply_forest(
            internal_model,
            data_validation_features,
            )
        blobs[:predicted_labels_validation] = Int.(predicted_labels_validation)
        predicted_proba_validation_twocols = apply_forest_proba(
            internal_model,
            data_validation_features,
            classes,
            )
        blobs[:predicted_proba_validation_twocols] =
            predicted_proba_validation_twocols
        predicted_proba_validation_onecol =
            binaryproba_twocolstoonecol(predicted_proba_validation_twocols)
        blobs[:predicted_proba_validation_onecol] =
            predicted_proba_validation_onecol
        predicted_proba_validation = predicted_proba_validation_onecol
        blobs[:predicted_proba_validation] = predicted_proba_validation
    else
        blobs[:numvalidation] = 0
    end

    if hastesting(dataset)
        blobs[:numtesting] = numtraining(dataset)
        data_testing_features, recordidlist_testing = getdata(
            dataset;
            testing=true,
            features=true,
            features_format=:matrix,
            )
        data_testing_labels = getdata(
            dataset;
            single_label = true,
            label_variable = label_variable,
            label_type = :integer,
            recordidlist = recordidlist_testing,
            )

        @assert(typeof(data_testing_labels) <: DataFrame)
        data_testing_labels = convert(Array, data_testing_labels)
        @assert(typeof(data_testing_labels) <: AbstractMatrix)
        @assert(size(data_testing_labels,2) == 1)
        data_testing_labels = data_testing_labels[:,1]
        blobs[:true_labels_testing] = data_testing_labels

        predicted_labels_testing = apply_forest(
            internal_model,
            data_testing_features,
            )
        blobs[:predicted_labels_testing] = Int.(predicted_labels_testing)
        predicted_proba_testing_twocols = apply_forest_proba(
            internal_model,
            data_testing_features,
            classes,
            )
        blobs[:predicted_proba_testing_twocols] =
            predicted_proba_testing_twocols
        predicted_proba_testing_onecol =
            binaryproba_twocolstoonecol(predicted_proba_testing_twocols)
        blobs[:predicted_proba_testing_onecol] =
            predicted_proba_testing_onecol
        predicted_proba_testing = predicted_proba_testing_onecol
        blobs[:predicted_proba_testing] = predicted_proba_testing
    else
        blobs[:numtesting] = 0
    end

    return SingleLabelBinaryRandomForestClassifier(blobs)
end
