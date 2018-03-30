function out=GenData(m,n,varargin)
nvarargin = length(varargin);
if(nvarargin>0)
    mode = varargin{1};
    switch mode
        case 'mvnorm'
            if(nvarargin == 3)
                mu = varargin{2};
                cov = varargin{3};
                rng('shuffle');
                out = mvnrnd(mu,cov,m); 
            else
            end
        case 'laplace'
            mu = varargin{2};
            sigma = varargin{3};
            rng('shuffle');
            u = rand(m, n)-0.5;
            b = sigma / sqrt(2);
            out = mu - b * sign(u).* log(1- 2* abs(u));
        case 'mixture'
            mu = varargin{2};
            cov = varargin{3};
            ratio = varargin{4};
            gm = gmdistribution(mu,cov,ratio{1});
            rng('shuffle');
            out = random(gm,m);
        case 't'
            nu = varargin{2};
            rng('shuffle');
            out = trnd(nu,[m,n]);
    end
else
end
end