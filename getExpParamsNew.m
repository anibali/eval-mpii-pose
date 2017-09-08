function p = getExpParamsNew(predidx)

% path to the directory containg ground truth 'annolist' and RELEASE structures
p.gtDir = './ground_truth/';
p.colorIdxs = [1 1];
p.partNames = {'right ankle','right knee','right hip','left hip','left knee','left ankle','right wrist','right elbow','right shoulder','left shoulder','left elbow','left wrist','neck','top head','avg full body'};
switch predidx
  % Cascaded architecture from Tompson et al., CVPR'15.
  %
  % http://www.cims.nyu.edu/~tompson/cs_portfolio.html
  % (Data format had to be modified slightly).
  case 1
    p.name = 'tompson';
    p.predFilename = 'preds/reference/tompson.h5';
    p.colorIdxs = [5 1];

  % Stacked hourglass validation set results made available by Newell et al.
  %
  % https://github.com/anewell/pose-hg-demo/blob/master/preds/valid-ours.h5
  case 2
    p.name = 'newell';
    p.predFilename = 'preds/reference/anewell-valid-ours.h5';
    p.colorIdxs = [1 1];

  % Stacked hourglass validation set results made available by Wei Yang
  % (aka bearpaw) with his PyTorch port of the original code.
  %
  % https://drive.google.com/open?id=0B63t5HSgY4SQaWh4WlJ6c0QxN0k
  case 3
    p.name = 'bearpaw-hg-s1-b1';
    p.predFilename = 'preds/reference/bearpaw-hg_s1_b1.mat';
    p.colorIdxs = [2 1];

  % Stacked hourglass validation set results made available by Wei Yang
  % (aka bearpaw) with his PyTorch port of the original code.
  %
  % https://drive.google.com/open?id=0B63t5HSgY4SQVnIzVmE2bkg3UHc
  case 4
    p.name = 'bearpaw-hg-s2-b1';
    p.predFilename = 'preds/reference/bearpaw-hg_s2_b1.mat';
    p.colorIdxs = [4 1];
end

p.colorName = getColor(p.colorIdxs);
p.colorName = p.colorName ./ 255;

end
