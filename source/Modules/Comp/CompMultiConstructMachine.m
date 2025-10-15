function [Datas, parameters] = CompMultiConstructMachine(Datas, parameters, methods, l)

% Generating Coeff for every gene series (col)
%             if parameters.multilevel.svmonly == 0
% 
%             
%             end
            %% Nested
            parameters = methods.Multi.Getcoeff(Datas, parameters);
            Datas = methods.Multi.nesteddatasvm(Datas, parameters, methods, l);
           
            %% Fit SVM
            [parameters] = methods.SVMonly.fitSVM(Datas, parameters, methods);
            

           
            % if parameters.multilevel.nested == 1
            %     Datas = methods.Multi.nesteddatasvm(Datas, parameters, methods, l);   % for level 0-l nested
            % else
            %     Datas = methods.Multi.datasvm(Datas, parameters, methods, l);   % for level l
            % end
            
           
            
            % Fit SVM
            % if parameters.svm.kernal == 1
            %     [parameters.multilevel.SVMModel] = methods.all.SVMmodel(Datas.X_Train, Datas.y_Train, ...
            %                                         'KernelFunction', 'RBF', 'KernelScale', 'auto');
            % else
            %     [parameters.multilevel.SVMModel] = methods.all.SVMmodel(Datas.X_Train, Datas.y_Train);%,...
            % end
end
