clear
clc

%% read shapefiles
fileFilter = './data/train/*.shp';
filenames = dir(fileFilter);
X = [];
Y = [];
T = [];
for k=1:length(filenames)
    k
    filename = [filenames(k).folder, '/', filenames(k).name];
    S = shaperead(filename, 'Attributes',{'occ_date','census_tra'});
%     S = shaperead(filename, 'Attributes',{'occ_date','census_tra'},...
%         'Selector', {@(v1) (strcmp(v1,'MOTOR VEHICLE THEFT')),'CATEGORY'});
    x = [S.X]';
    y = [S.Y]';
    t = str2double({S.occ_date});
    t = t';
    t = t(~isnan(t));
    X = [X;x];
    Y = [Y;y];
    T = [T;t];
end
save('ACFS', 'X','Y','T');

%% merge by period
load('SC')
data = mergeByPeriod(X,Y,T,'1MO');
bar(1:length(data.summary), data.summary);

%% draw image
Portland = './data/police_district/Portland_Police_Districts.shp';
% S_Portland = shaperead(Portland);
info_Portland = shapeinfo(Portland);
bbox = info_Portland.BoundingBox;
% sz_ft = bbox(2,:) - bbox(1,:);
% w_ft = sz_ft(1); h_ft = sz_ft(2); 
% w_mi = distdim(w_ft,'ft','mi');
% h_mi = distdim(h_ft,'ft','mi');
gridSz = 600; % feet
xCoor = bbox(1,1):gridSz:bbox(2,1);
yCoor = bbox(1,2):gridSz:bbox(2,2);
[XCoor, YCoor] = meshgrid(xCoor, yCoor);
cols = length(yCoor);
rows = length(xCoor);
Rects = zeros(cols*rows, 4);
% up-left corner
Rects(:,1) = XCoor(:);
Rects(:,2) = YCoor(:);
% down-right corner
Rects(:,3) = XCoor(:) + gridSz;
Rects(:,4) = YCoor(:) + gridSz;
img = zeros(cols, rows);
filename = 'BURG_1MO.gif';
for k = 1:length(data.summary)
    coords = data.detail{k};
    Xcord = coords(:,1);
    Ycord = coords(:,2);
    for ii=1:length(Rects)
        ind = Xcord>Rects(ii,1) & Xcord<Rects(ii,3) & Ycord>Rects(ii,2) & Ycord<Rects(ii,4);
        img(ii) = sum(ind);
    end
    img = rescaleMat(img, 1, 255);
    if k == 1
        imwrite(img,filename,'gif', 'Loopcount',inf);
    else
        imwrite(img,filename,'gif','WriteMode','append');
    end
%     imshow(img,[]);
%     w = waitforbuttonpress;
end

% cols = w_ft/gridSz;
% rows = h_ft/gridSz;
% N = cols * rows;
% 
% area_pred_mi = [0.25, 0.75]; % mi^2
% mi2ft = 5280;
% area_pred_ft = area_pred_mi * mi2ft^2; % ft^2
% N_pred = area_pred_ft / (grid_ft*grid_ft);