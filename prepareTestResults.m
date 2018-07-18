% Prepare test set results for submission to MPII for evaluation.
%
% Input:  Matlab/HDF5 file containing a single field, 'preds', which is
%         a [2 x 16 x n] or [n x 16 x 2] tensor describing test set joint
%         predictions. These predictions are expected to correspond with the
%         annotations in annot/test.h5.
% Output: A Matlab file containing predictions in submission-ready format.

%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IN_FILE = 'preds/test_preds.h5';
OUT_FILE = 'pred_keypoints_mpii.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('annot/mpii_human_pose_v1_u12_1', 'RELEASE');

if exist ("OCTAVE_VERSION", "builtin") > 0
  % Load test set annotations (joint ground truths will be missing)
  test_annot = load('annot/test.h5', 'index',  'person');
  test_indices = test_annot.index + 1;
  test_persons = test_annot.person + 1;

  % Load predictions
  test_preds = load(IN_FILE, 'preds');
  test_preds = test_preds.preds;
else
  % Load test set annotations (joint ground truths will be missing)
  test_indices = h5read('annot/test.h5', '/index') + 1;
  test_persons = h5read('annot/test.h5', '/person') + 1;

  % Load predictions
  test_preds = h5read('preds/test_preds.h5', '/preds');
end

if (size(test_preds, 3) == 2)
  test_preds = permute(test_preds, [3, 2, 1]);
end

% Check that the number of predictions is correct
n_test_examples = length(test_indices);

% Validate the number of predictions
n_test_preds = size(test_preds, 3);
if (n_test_preds ~= n_test_examples)
  switch n_test_preds
    case 2958
      fprintf('! It looks like your predictions are from the validation set,\n')
      fprintf('! but this script works for test set predictions only.\n')
    case 22246
      fprintf('! It looks like your predictions are from the training set,\n')
      fprintf('! but this script works for test set predictions only.\n')
  end
  error(sprintf('Expected %d predictions, got %d', n_test_examples, n_test_preds))
end

pred = RELEASE.annolist;
n_joints = size(test_preds, 2); % Should be 16

centers = cell(2, 0);
thorax_preds = cell(2, 0);

for i = 1:n_test_examples
  % All examples in test.h5 should be test examples
  assert(RELEASE.img_train(test_indices(i)) == 0);

  idx = test_indices(i);

  x = cell(1, n_joints);
  y = cell(1, n_joints);
  id = cell(1, n_joints);
  for j = 1:n_joints
    x{j} = test_preds(1, j, i);
    y{j} = test_preds(2, j, i);
    id{j} = j - 1; % Stored joint ID is zero-based
  end

  point = struct('point', struct('x', x, 'y', y,'id', id));
  pred(idx).annorect(test_persons(i)).annopoints = point;

  centers(:, end+1) = {
    pred(idx).annorect(test_persons(i)).objpos.x,
    pred(idx).annorect(test_persons(i)).objpos.y
  };
  thorax_preds(:, end+1) = {
    test_preds(1, 8, i),
    test_preds(2, 8, i)
  };
end

pred = pred(RELEASE.img_train == 0);

correlation = corr(cell2mat(centers)', cell2mat(thorax_preds)');

fprintf('Correlation between person centers and thorax predictions:\n');
display(diag(correlation));

if min(diag(correlation)) < 0.5
  fprintf('! Low correlation between predicted thorax positions and\n');
  fprintf('! annotated person centers detected. This could indicate a\n');
  fprintf('! mismatch in example ordering, or very poor predictions.\n');
end

save(OUT_FILE, 'pred', '-v7');
