function p = getExpParamsNew(predidx)

% path to the directory containg ground truth 'annolist' and RELEASE structures
p.gtDir = './ground_truth/';
p.colorIdxs = [1 1];
p.partNames = {'right ankle','right knee','right hip','left hip','left knee','left ankle','right wrist','right elbow','right shoulder','left shoulder','left elbow','left wrist','neck','top head','avg full body'};
switch predidx
  case 0
    p.name = 'pytorch-hg4';
    p.predFilename = 'preds/pytorch-hg4-preds.mat';
    p.colorIdxs = [1 1];
  case 1
    p.name = 'pytorch-hg8';
    p.predFilename = 'preds/pytorch-hg8-preds.mat';
    p.colorIdxs = [2 1];
end

p.colorName = getColor(p.colorIdxs);
p.colorName = p.colorName ./ 255;

end
