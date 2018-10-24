function [input_list,input_data]=Collate_failed_run_data(filename_search,varargin)
dbstop if error
jj=1;

if nargin == 0
    filename_search='';
    filedata=dir('*.log');
else
    filedata=dir(['*' filename_search '*.log']);
end

num_files=length(filedata);
input_list=cell(num_files,1);
input_data=NaN(num_files,10);
for ii=1:num_files
    fileID=fopen(filedata(ii).name,'r');
    full_file_text=fscanf(fileID,'%c',Inf);
    if contains(full_file_text,'=')==1
        fclose(fileID);
    else
        file_text=strsplit(full_file_text,'\n');
        for kk = 1:length(file_text)
            file_text_split=strsplit(file_text{kk},',');
            if length(file_text_split)==10
                input_list{jj,1}=file_text{kk};
                
                for ll=1:10
                    input_data(jj,ll)=str2double(file_text_split{ll});
                end
            end
        end
        jj=jj+1;
        fclose(fileID);
    end
end
input_data=input_data(isnan(input_data)~=1);
input_data=reshape(input_data,length(input_data)/10,10);

figNames=cell(10,1);
figNames{1}='SumE';
figNames{2}='DeltaE';
figNames{3}='SumT';
figNames{4}='DeltaT';
figNames{5}='tI';
figNames{6}='Lo';
figNames{7}='SI';
figNames{8}='GiicI';
figNames{9}='GI';
figNames{10}='DeltaSigma_min';
for ii=1:10
    figure(ii)
    hold on
    plot(1:length(input_data),input_data(:,ii),'bx')
    title([filename_search ' ' figNames{ii}],'interpreter','none')
%     savefig([filename_search '_' figNames{ii}])
%     saveas(gcf,[filename_search '_' figNames{ii} '.emf'])
end

end