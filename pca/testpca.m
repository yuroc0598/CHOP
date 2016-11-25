clear;
data=load('defang.train.vector.normal');
[coeff ,score,latent]=pca(data);

norm=0;
for i=1:size(coeff,1)
norm=norm+coeff(1,i)*coeff(1,i);

end

%centered=score*coeff';

da2=load('defang.train.vector.afterPCA');
da3=load('defang.train.vector.normal');
K=convhulln(da2);

