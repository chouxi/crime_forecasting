function [x,y] = images2inputs(countMaps)
[nt,ny,nx] = size(countMaps);
X = [];
Y = [];
T = [];
L = [];
for k = 1:nt
    img = squeeze(countMaps(k,:,:));
    label = img(:); L = [L;label];
    x = repmat(1:nx,ny,1); x = x(:); X = [X;x];
    y = repmat([1:ny]',1,nx); y = y(:); Y = [Y;y];
    t = k*ones(nx*ny,1); T = [T;t];
end
x = [X Y T];
y = L;