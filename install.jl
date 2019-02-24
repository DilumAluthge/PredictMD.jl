import Pkg; 
Pkg.Registry.update(); 
Pkg.update(); 
Pkg.Registry.add(Pkg.Registry.RegistrySpec(url="https://github.com/JuliaRegistries/General")); 
Pkg.Registry.update(); 
Pkg.update(); 
Pkg.add(Pkg.PackageSpec(url="https://github.com/bcbi/PredictMD.jl", rev="master")); 
Pkg.build("PredictMD"); 
Pkg.add(Pkg.PackageSpec(url="https://github.com/bcbi/PredictMDExtra.jl", rev="master")); 
Pkg.build("PredictMDExtra"); 
Pkg.add(Pkg.PackageSpec(url="https://github.com/bcbi/PredictMDFull.jl", rev="master")); 
Pkg.build("PredictMDFull"); 
ENV["JULIA_DEBUG"] = "all"; 
import PredictMD; 
import PredictMDExtra; 
import PredictMDFull; 
println("PredictMD was installed successfully.");
println("You are now ready to use PredictMD.");
println("For help, visit https://predictmd.net");
