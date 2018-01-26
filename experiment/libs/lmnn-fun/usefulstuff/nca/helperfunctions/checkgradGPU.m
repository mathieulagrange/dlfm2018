function [d,dy,dh] = check(f, X, e, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11);

% checkgrad checks the derivatives in a function, by comparing them to finite
% differences approximations. The partial derivatives and the approximation
% are printed and the norm of the diffrence divided by the norm of the sum is
% returned as an indication of accuracy.
%
% usage: checkgrad('f', X, e, P1, P2, ...)
%
% where X is the argument and e is the small perturbation used for the finite
% differences. and the P1, P2, ... are optional additional parameters which
% get passed to f. The function f should be of the type 
%
% [fX, dfX] = f(X, P1, P2, ...)
%
% where fX is the function value and dfX is a vector of partial derivatives.
%
% Carl Edward Rasmussen, 2001-08-01.

argstr = [f, '(X'];                            % assemble function call strings
argstrd = [f, '(X+dx'];
for i = 1:(nargin - 3)
  argstr = [argstr, ',P', int2str(i)];
  argstrd = [argstrd, ',P', int2str(i)];
end
argstr = [argstr, ')'];
argstrd = [argstrd, ')'];

[y dy] = eval(argstr);                         % get the partial derivatives dy

dh = gpuArray(zeros(length(X),1));
for j = 1:length(X)
  dx = zeros(length(X),1);
  dx(j) = dx(j) + e;                               % perturb a single dimension
  y2 = eval(argstrd);
  dx = -dx ;
  y1 = eval(argstrd);
  dh(j) = (y2 - y1)/(2*e);
  norm(dh(1:j)-dy(1:j))/norm(dh(1:j)+dy(1:j))
  disp([num2str(j) ' out of norm ' num2str(length(X))]);
	% for testing purposes
	%if j == 10
	%	break
	%end
        disp(['dy: ' num2str(norm(dy))])
        disp(['dhj: ' num2str(norm(dh(1:j)))])
        disp(['dyj: ' num2str(norm(dy(1:j)))])
%dh(1:j)
%dy(1:j)
end
%keyboard
%disp([dy dh])                                          % print the two vectors
d = norm(dh-dy)/norm(dh+dy);       % return norm of diff divided by norm of sum
