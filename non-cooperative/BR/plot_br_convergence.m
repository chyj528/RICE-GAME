b = [];
a = zeros(12,20)
for k = 1:20
    for i = 1:12
        a(i) = norm(U_br(i,:,k+1) - U_br(i,:,k)); 
    end
    
    b = [b a(i)];
end
scatter(1:20,b)