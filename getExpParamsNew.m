function p = getExpParamsNew(predidx)

colours = [
  [ 0.50980392  0.07843137  0.62745098],
  [ 0.03921569  0.70588235  0.35294118],
  [ 0.          0.35294118  0.78431373],
  [ 0.66666667  0.03921569  0.23529412],
  [ 0.07843137  0.82352941  0.8627451 ],
  [ 0.98039216  0.47058824  0.31372549],
  [ 0.98039216  0.47058824  0.98039216],
  [ 0.94117647  0.94117647  0.19607843],
  [ 0.62745098  0.98039216  0.50980392],
  [ 0.          0.43137255  0.50980392],
  [ 0.          0.62745098  0.98039216],
  [ 0.98039216  0.90196078  0.74509804],
];

% path to the directory containg ground truth 'annolist' and RELEASE structures
p.gtDir = './ground_truth/';
p.partNames = {'right ankle','right knee','right hip','left hip','left knee','left ankle','right wrist','right elbow','right shoulder','left shoulder','left elbow','left wrist','neck','top head','avg full body'};
switch predidx
  % Cascaded architecture from Tompson et al., CVPR'15.
  %
  % Validation set predictions were extracted from the bundle of
  % prediction results made available online by Tompson et al.
  %
  % http://www.cims.nyu.edu/~tompson/cs_portfolio.html
  case 1
    p.name = 'Tompson et al., CVPR''15';
    p.predFilename = 'preds/reference/tompson.h5';

  % Stacked hourglass architecture from Newell et al., ECCV'16.
  %
  % Validation set predictions were obtained from the pretrained
  % 8-stack model made available online by Newell et al. using
  % their own evaluation code.
  %
  % https://github.com/anewell/pose-hg-demo
  case 2
    p.name = 'Newell et al., ECCV''16';
    p.predFilename = 'preds/reference/newell.h5';

  % Stacked hourglass validation set results made available by Wei Yang
  % (aka bearpaw) with his PyTorch port of the original code.
  %
  % https://drive.google.com/open?id=0B63t5HSgY4SQaWh4WlJ6c0QxN0k
  case 3
    p.name = 'bearpaw-hg-s1-b1';
    p.predFilename = 'preds/reference/bearpaw-hg_s1_b1.mat';

  % Stacked hourglass validation set results made available by Wei Yang
  % (aka bearpaw) with his PyTorch port of the original code.
  %
  % https://drive.google.com/open?id=0B63t5HSgY4SQVnIzVmE2bkg3UHc
  case 4
    p.name = 'bearpaw-hg-s2-b1';
    p.predFilename = 'preds/reference/bearpaw-hg_s2_b1.mat';

  % Stacked hourglass validation set results made available by Wei Yang
  % (aka bearpaw) with his PyTorch port of the original code.
  %
  % https://drive.google.com/open?id=0B63t5HSgY4SQRmhiLVdJYmxKWXc
  case 5
    p.name = 'bearpaw-hg-s8-b1';
    p.predFilename = 'preds/reference/bearpaw-hg_s8_b1.mat';
end

p.colorName = colours(mod(predidx - 1, size(colours, 1)) + 1, :);

end
