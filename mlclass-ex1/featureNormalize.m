function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

% You need to set these values correctly
X_norm = X;
mu = zeros(1, size(X, 2));
sigma = zeros(1, size(X, 2));

mu = mean(X(:, 1:2));
sigma = std(X(:, 1:2));
X_norm(:, 1) = (X_norm(:, 1) - mu(:, 1)) ./ sigma(:, 1);
X_norm(:, 2) = X_norm(:, 2) - mu(:, 2) ./ sigma(:, 2);
mu = mean(X(:, 1:2));
sigma = std(X(:, 1:2));

% X_norm(:, 1:2) = (X(:, 1:2) - mu) ./ sigma;




% X_norm(:, 1) = (X(:, 1) - mean(X(:, 1)))/std(X(:, 1));
% X_norm(:, 2) = (X(:, 2) - mean(X(:, 2)))/std(X(:, 2));
% fprintf('First 10 examples from the dataset: \n');
% fprintf(' x = [%.0f %.0f], y = %.0f \n', [X(1:10,:)]');
% ====================== YOUR CODE HERE ======================
% Instructions: First, for each feature dimension, compute the mean
%               of the feature and subtract it from the dataset,
%               storing the mean value in mu. Next, compute the
%               standard deviation of each feature and divide
%               each feature by it's standard deviation, storing
%               the standard deviation in sigma.
%
%               Note that X is a matrix where each column is a
%               feature and each row is an example. You need
%               to perform the normalization separately for
%               each feature.
%
% Hint: You might find the 'mean' and 'std' functions useful.
%









% ============================================================

end
