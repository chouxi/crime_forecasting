function model = gaussian_process(xNorm, y)
model = fitrgp(xNorm,y,'KernelFunction','squaredexponential', 'Sigma', 1.5);