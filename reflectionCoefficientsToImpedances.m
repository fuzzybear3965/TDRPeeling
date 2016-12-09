function impedances = reflectionCoefficientsToImpedances(ref_coeffs,ref_impedance)
if size(ref_coeffs,2) == 4
   ref_coeffs = ref_coeffs(:,4);
elseif size(ref_coeffs,2) == 1
   ref_coeffs = ref_coeffs;
end
impedances = zeros(length(ref_coeffs),1);
impedances(1) = ref_impedance * (1+ref_coeffs(1))/(1-ref_coeffs(1));
for i = 2:length(ref_coeffs)
   impedances(i) = impedances(i-1) * (1+ref_coeffs(i))/(1-ref_coeffs(i));
end
end
