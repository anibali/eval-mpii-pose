addpath ('eval')

fprintf('# MPII single-person pose evaluation script\n')

range = 0:0.01:0.5;
predidxs = [0, 1, 2];
subset_annot_file = 'annot/valid.h5';

tableDir = './latex'; if (~exist(tableDir,'dir')), mkdir(tableDir); end
plotsDir = './plots'; if (~exist(plotsDir,'dir')), mkdir(plotsDir); end
tableTex = cell(length(predidxs)+1,1);

% load ground truth
load('annot/mpii_human_pose_v1_u12_1', 'RELEASE');
annolist = RELEASE.annolist;

subset = load(subset_annot_file, 'index', 'person');
subset_indices = subset.index + 1;
annolist_subset = annolist(subset_indices);
single_person_subset = RELEASE.single_person(subset_indices);

annolist_subset_flat = struct('image',[],'annorect',[]);
n = 0;
for imgidx = 1:length(annolist_subset)
  rect_gt = annolist_subset(imgidx).annorect;
  ridx = subset.person(imgidx) + 1;
  if (isfield(rect_gt(ridx),'objpos') && ~isempty(rect_gt(ridx).objpos))
    n = n + 1;
    annolist_subset_flat(n).image.name = annolist_subset(imgidx).image.name;
    annolist_subset_flat(n).annorect = rect_gt(ridx);
  end
end

% represent ground truth as a matrix 2x14xN_images
gt = annolist2matrix(annolist_subset_flat);
% compute head size
headSize = getHeadSizeAll(annolist_subset_flat);

pckAll = zeros(length(range),16,length(predidxs));

for i = 1:length(predidxs);
  % load predictions
  p = getExpParamsNew(predidxs(i));
  load(p.predFilename, 'preds');
  if (size(preds)(1) == 2)
    preds = permute(preds, [3, 2, 1]);
  end

  % Check that there are the same number of predictions and ground truth
  % annotations. If this assertion fails, a likely cause is a mismatch in
  % subsets (eg predictions are for the training set but ground truth
  % annotations are for the validation set).
  assert(length(preds) == length(gt));

  pred_flat = annolist_subset_flat;
  for idx = 1:length(preds);
    for pidx = 1:length(pred_flat(idx).annorect.annopoints.point);
      joint = pred_flat(idx).annorect.annopoints.point(pidx).id + 1;
      xy = preds(idx, joint, :);
      pred_flat(idx).annorect.annopoints.point(pidx).x = xy(1);
      pred_flat(idx).annorect.annopoints.point(pidx).y = xy(2);
    end
  end

  % pred = annolist2matrix(pred_flat(single_person_subset_flat == 1));
  pred = annolist2matrix(pred_flat);
  % only gt is allowed to have NaN
  pred(isnan(pred)) = inf;

  % compute distance to ground truth joints
  dist = getDistPCKh(pred,gt,headSize);

  % compute PCKh
  pck = computePCK(dist,range);

  % plot results
  [row, header] = genTablePCK(pck(end,:),p.name);
  tableTex{1} = header;
  tableTex{i+1} = row;

  pckAll(:,:,i) = pck;

  auc = area_under_curve(scale01(range),pck(:,end));
  fprintf('%s, AUC: %1.1f\n',p.name,auc);
end

% Save results
fid = fopen([tableDir '/pckh.tex'],'wt');assert(fid ~= -1);
for i=1:length(tableTex),fprintf(fid,'%s\n',tableTex{i}); end; fclose(fid);

% plot curves
bSave = true;
plotCurveNew(squeeze(pckAll(:,end,:)),range,predidxs,'PCKh total, MPII',[plotsDir '/pckh-total-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[1 6],:),2)),range,predidxs,'PCKh ankle, MPII',[plotsDir '/pckh-ankle-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[2 5],:),2)),range,predidxs,'PCKh knee, MPII',[plotsDir '/pckh-knee-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[3 4],:),2)),range,predidxs,'PCKh hip, MPII',[plotsDir '/pckh-hip-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[7 12],:),2)),range,predidxs,'PCKh wrist, MPII',[plotsDir '/pckh-wrist-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[8 11],:),2)),range,predidxs,'PCKh elbow, MPII',[plotsDir '/pckh-elbow-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[9 10],:),2)),range,predidxs,'PCKh shoulder, MPII',[plotsDir '/pckh-shoulder-mpii'],bSave,range(1:5:end));
plotCurveNew(squeeze(mean(pckAll(:,[13 14],:),2)),range,predidxs,'PCKh head, MPII',[plotsDir '/pckh-head-mpii'],bSave,range(1:5:end));
