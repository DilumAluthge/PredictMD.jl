using DataFrames
using GLM
using MLBase
using StatsBase

struct SingleLabelBinaryLogisticClassifier <:
        AbstractSingleLabelBinaryClassifier
    blobs::T where T <: Associative
end

function SingleLabelBinaryLogisticClassifier(
        dataset::AbstractHoldoutTabularDataset,
        label_variable::Symbol;
        intercept::Bool = true,
        family::Distribution = Binomial(),
        link::Link = LogitLink(),
        )

    blobs = Dict{Symbol, Any}()

    feature_variables = dataset.blobs[:feature_variables]

    formula_object = generate_formula_object(
        label_variable,
        feature_variables,
        intercept = intercept,
        )
    blobs[:formula_object] = formula_object

    if !hastraining(dataset)
        error("dataset has no training data")
    end
    blobs[:numtraining] = numtraining(dataset)
    data_training_labelandfeatures, recordidlist_training = getdata(
        dataset;
        training = true,
        single_label = true,
        label_variable = label_variable,
        label_type = :integer,
        features = true,
        )
    ###
    blobs[:data_training_labelandfeatures] = data_training_labelandfeatures
    ####
    blobs[:recordidlist_training] = recordidlist_training
    data_training_features = getdata(
        dataset;
        features = true,
        recordidlist = recordidlist_training,
        )
    ###
    blobs[:data_training_features] = data_training_features
    ####
    data_training_labels = getdata(
        dataset;
        single_label = true,
        label_variable = label_variable,
        label_type = :integer,
        recordidlist = recordidlist_training,
        )
    blobs[:true_labels_training] = convert(Array,data_training_labels)

    internal_model = glm(
        formula_object,
        data_training_labelandfeatures,
        family,
        link,
        )
    @assert(typeof(internal_model) <: DataFrames.DataFrameRegressionModel)
    blobs[:internal_model] = internal_model

    fitted_predicted_proba_training = DataFrames.predict(internal_model)
    predicted_proba_training = DataFrames.predict(
        internal_model,
        data_training_features,
        )
    if (
            !(
                all(
                    isapprox(
                        fitted_predicted_proba_training,
                        predicted_proba_training
                        )
                    )
                )
            )
        msg1 = "Equivalent methods for calculating predicted probabilities" *
            "on the training set yielded different results."
        deviations = fitted_predicted_proba_training .-
            predicted_proba_training
        msg2 = "\nTotal (sum) deviation: $(sum(deviations))"
        msg3 = "\nMax deviation: $(maximum(deviations))"
        msg4 = "\nMean deviation: $(mean(deviations))"
        warn(msg1*msg2*msg3*msg4)
    end
    blobs[:fitted_predicted_proba_training] =
        fitted_predicted_proba_training
    blobs[:predicted_proba_training] =
        predicted_proba_training
    blobs[:predicted_proba_training_onecol] =
        predicted_proba_training
    predicted_proba_training_twocols = binaryproba_onecoltotwocols(
        predicted_proba_training,
        )
    blobs[:predicted_proba_training_twocols] =
        predicted_proba_training_twocols
    predicted_labels_training =
        classify(predicted_proba_training_twocols').-1
    blobs[:predicted_labels_training] = predicted_labels_training

    if hasvalidation(dataset)
        blobs[:numvalidation] = numvalidation(dataset)
        data_validation_features, recordidlist_validation = getdata(
            dataset;
            validation = true,
            features = true,
            )
        ###
        blobs[:data_validation_features] = data_validation_features
        ####
        blobs[:recordidlist_validation] = recordidlist_validation
        data_validation_labels = getdata(
            dataset;
            single_label = true,
            label_variable = label_variable,
            label_type = :integer,
            recordidlist = recordidlist_validation,
            )
        blobs[:true_labels_validation] = convert(Array,data_validation_labels)
        predicted_proba_validation = GLM.predict(
            internal_model,
            data_validation_features,
            )
        blobs[:predicted_proba_validation] =
            predicted_proba_validation
        blobs[:predicted_proba_validation_onecol] =
            predicted_proba_validation
        predicted_proba_validation_twocols = binaryproba_onecoltotwocols(
            predicted_proba_validation,
            )
        blobs[:predicted_proba_validation_twocols] =
            predicted_proba_validation_twocols
        predicted_labels_validation =
            classify(predicted_proba_validation_twocols').-1
        blobs[:predicted_labels_validation] = predicted_labels_validation
    else
        blobs[:numvalidation] = 0
    end

    if hastesting(dataset)
        blobs[:numtesting] = numtesting(dataset)
        data_testing_features, recordidlist_testing = getdata(
            dataset;
            testing = true,
            features = true,
            )
        ###
        blobs[:data_testing_features] = data_testing_features
        ####
        blobs[:recordidlist_testing] = recordidlist_testing
        data_testing_labels = getdata(
            dataset;
            single_label = true,
            label_variable = label_variable,
            label_type = :integer,
            recordidlist = recordidlist_testing,
            )
        blobs[:true_labels_testing] = convert(Array,data_testing_labels)
        predicted_proba_testing = GLM.predict(
            internal_model,
            data_testing_features,
            )
        blobs[:predicted_proba_testing] =
            predicted_proba_testing
        blobs[:predicted_proba_testing_onecol] =
            predicted_proba_testing
        predicted_proba_testing_twocols = binaryproba_onecoltotwocols(
            predicted_proba_testing
            )
        blobs[:predicted_proba_testing_twocols] =
            predicted_proba_testing_twocols
        predicted_labels_testing =
            classify(predicted_proba_testing_twocols').-1
        blobs[:predicted_labels_testing] = predicted_labels_testing
    else
        blobs[:numtesting] = 0
    end

    return SingleLabelBinaryLogisticClassifier(blobs)

end

function numtraining(m::AbstractSingleLabelBinaryClassifier)
    return m.blobs[:numtraining]
end
function numvalidation(m::AbstractSingleLabelBinaryClassifier)
    return m.blobs[:numvalidation]
end
function numtesting(m::AbstractSingleLabelBinaryClassifier)
    return m.blobs[:numtesting]
end

hastraining(m::AbstractSingleLabelBinaryClassifier) = numtraining(m) > 0
hasvalidation(m::AbstractSingleLabelBinaryClassifier) = numvalidation(m) > 0
hastesting(m::AbstractSingleLabelBinaryClassifier) = numtesting(m) > 0
