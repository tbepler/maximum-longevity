
data{
    int <lower=0> N; //number of data points
    real <lower=0> age_at_death[N]; //ages at death
}

parameters{
    real<lower=max(age_at_death),upper=1000> max_lifespan;
    real<lower=0> alpha;
    real<lower=0> beta;
}

transformed parameters{
    real<lower=0> age_transformed[N];
    for (i in 1:N){
        age_transformed[i] = age_at_death[i]/max_lifespan;
    }
}

model{
    //priors on parameters
    
    // model of age at death
    // increment directly to ensure constants are preserved
    increment_log_prob(beta_lpdf(age_transformed | alpha, beta));
}