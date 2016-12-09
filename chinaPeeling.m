function reflection_coefficients = chinaPeeling(unpeeled_data,step_amplitude)
left_lattice = zeros(length(unpeeled_data)+1,1);
right_lattice = zeros(length(unpeeled_data)+1,1);
reflection_coefficients = zeros(length(unpeeled_data)+1,1);
g_product = 1;
temp_ref_volt = 0;
if length(unpeeled_data) >= 1
    reflection_coefficients(2) = unpeeled_data(1);
    left_lattice(2) = step_amplitude;
    g_product = g_product* (1-reflection_coefficients(2)^2);
else
    return
end
if length(unpeeled_data) >= 2
    temp_ref_volt = (1 - reflection_coefficients(2))*right_lattice(2) + ...
        reflection_coefficients(2)*left_lattice(2);
    reflection_coefficientopens(3) = (unpeeled_data(2) - temp_ref_volt)/g_product;
    left_lattice(3) = left_lattice(2)*(1+reflection_coefficients(2));
    right_lattice(2) = left_lattice(3)*reflection_coefficients(3);
    g_product = g_product*(1-reflection_coefficients(3)^2);
else
    return
end
for i = 3:length(unpeeled_data)
    left_lattice(i+1) = left_lattice(i)*(1+reflection_coefficients(i));
    left_lattice(i) = left_lattice(i-1)*(1+reflection_coefficients(i-1))+...
        right_lattice(i-1)*(-reflection_coefficients(i-1));
    for k = i-2:2
        right_lattice(k+1) = reflection_coefficients(k+2)*left_lattice(k+2)+...
            (1-reflection_coefficients(k+2))*right_lattice(k+2);
        left_lattice(k+1) = (1+reflection_coefficients(k))*left_lattice(k)+...
            (-reflection_coefficients(k))*right_lattice(k);
    end
    right_lattice(2) = left_lattice(3)*reflection_coefficients(3) + ...
        right_lattice(3)*(1-reflection_coefficients(3));
    temp_ref_volt = (1 - reflection_coefficients(2))*right_lattice(2) + ...
        reflection_coefficients(2)*left_lattice(2);
    reflection_coefficients(i+1) = (unpeeled_data(i) - temp_ref_volt)/g_product;
    g_product = g_product*(1-reflection_coefficients(i+1)^2);
    d_increase = left_lattice(i+1)*reflection_coefficients(i+1);
    right_lattice(i) = right_lattice(i)+d_increase;
    for k = i-2:1
        d_increase = d_increase*(1-reflection_coefficients(k+2));
        right_lattice(k+1) = right_lattice(k+1) + d_increase;
    end
end
reflection_coefficients = reflection_coefficients(2:end);
end