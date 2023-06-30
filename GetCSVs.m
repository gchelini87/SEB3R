function [labels, fileList]=GetCSVs(pathdir, prefixToStrip)
    % Detect all CSVs in a folder. It works by extracting all
    % files that match the following regex: (prefix)(label)(suffix)
    % Arguments:
    % - pathdir: the working directory
    % - prefixStrip: the expected prefix for each csv file

    files = dir(pathdir);
    nfiles = size(files);
    fileList = {};
    labels = {};
    if isstring(prefixToStrip)
        prefixToStrip = prefixToStrip.char;
    end
    suffixToStrip = '.csv';
    for i = 1:nfiles
        filename = files(i).name;
        if endsWith(filename, suffixToStrip) && startsWith(filename, prefixToStrip);
            stripped = filename(length(prefixToStrip)+1:end-length(suffixToStrip));
            labels{end+1} = stripped;
            fileList{end+1} = filename;
        end
    end
end

