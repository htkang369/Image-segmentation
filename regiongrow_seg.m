%%%%
%%%%  In this function, I used region grow algorithms to color gray-scale image
%%%%  applying frontier.
%%%%  
%%%%  COLOR:Before adding color on different area, I set different numbers on each
%%%%  area and then add colors according to the numbers.
%%%%
%%%%  USE:In this program, changing variable threshold can change the
%%%%  result of segmentation
%%%%  

function A = regiongrow_seg(ori_ima)
    
    b = ori_ima;
    re = double(b);
    out = zeros(size(b));

    %% region grow
    threshold = 25; % threashold, in textbook, model.t = threshold * threshold;
    max_range = size(b,1)*size(b,2); % control the maxium number of colors
    new_color = 1:1:max_range; % new color array
    i = 1; % index of new_color
    [height,width] = size(re); % get height and width
    front = [];  % frontier
    f_index = 0; % size of frontier
    seed_array = []; % to store seed that has been used 
    model = zeros(4,max_range); % store model parameters

    for h = 2:height-1
        for w = 2:width-1

            if ismember(out(h,w),seed_array)  % if current coordinate has been labeled, continue
                continue;
            else             
                seed = new_color(i); % seed is new color, initialize new color            
                seed_array(i) = seed; % add label into seed_array
                i = i + 1;           
                ori_color = re(h,w); % get original color

                % initialization model
                model(1,i-1) = ori_color;
                model(2,i-1) = ori_color * ori_color;
                model(3,i-1) = 1;
                model(4,i-1) = threshold*threshold;

                % push coordinates into frontier
                front(f_index+1,1) = h;
                front(f_index+1,2) = w;  
                f_index = size(front,1); 

                % set new label to output image
                out(h,w) = seed; 

                while(size(front,1)~=0)
                    o_h = front(end,1); % store the popped coordinate 
                    o_w = front(end,2);
                    front(end,:) = []; % pop last item
                    f_index = size(front,1);

                    if o_h == 1   % care about bondary
                        continue;
                    else
                        val = re(o_h-1,o_w); % neighbor value
                        mu = model(1,i-1)/model(3,i-1);
                        sigma = model(2,i-1)/model(3,i-1) - mu*mu;
                        d_2 = (val-mu)*(val-mu);
                        if d_2 <= model(4,i-1);
                            flag = 1;
                        else
                            flag = 0;
                        end

                        if flag==1 && out(o_h-1,o_w)~=seed && ismember(out(o_h-1,o_w),seed_array)==0 % whether the pixel above current has same color                                                             
                            front(f_index+1,1) = o_h-1; % push                                 
                            front(f_index+1,2) = o_w;
                            f_index = size(front,1);
                            out(o_h-1,o_w) = seed; % set as new color
                            % update model
                            model(1,i-1) = model(1,i-1) + val;
                            model(2,i-1) = model(2,i-1) + val*val;
                            model(3,i-1) = model(3,i-1) + 1;
                        end
                    end

                    if o_w == width   
                        continue;
                    else
                        val = re(o_h,o_w+1); % neighbor value
                        mu = model(1,i-1)/model(3,i-1);
                        sigma = model(2,i-1)/model(3,i-1) - mu*mu;
                        d_2 = (val-mu)*(val-mu);
                        if d_2 <= model(4,i-1);
                            flag = 1;
                        else
                            flag = 0;
                        end
                        if flag==1 && out(o_h,o_w+1)~=seed  && ismember(out(o_h,o_w+1),seed_array)==0% whether the pixel right current has same color
                            front(f_index+1,1) = o_h;
                            front(f_index+1,2) = o_w+1;
                            f_index = size(front,1);
                            out(o_h,o_w+1) = seed;
                            % update model
                            model(1,i-1) = model(1,i-1) + val;
                            model(2,i-1) = model(2,i-1) + val*val;
                            model(3,i-1) = model(3,i-1) + 1;
                        end
                    end

                    if o_h == height
                        continue;
                    else
                        val = re(o_h+1,o_w); % neighbor value
                        mu = model(1,i-1)/model(3,i-1);
                        sigma = model(2,i-1)/model(3,i-1) - mu*mu;
                        d_2 = (val-mu)*(val-mu);
                        if d_2 <= model(4,i-1);
                            flag = 1;
                        else
                            flag = 0;
                        end
                        if flag==1 && out(o_h+1,o_w)~=seed && ismember(out(o_h+1,o_w),seed_array)==0% whether the pixel below current has same color
                            front(f_index+1,1) = o_h+1;
                            front(f_index+1,2) = o_w;
                            f_index = size(front,1);
                            out(o_h+1,o_w) = seed;
                            % update model
                            model(1,i-1) = model(1,i-1) + val;
                            model(2,i-1) = model(2,i-1) + val*val;
                            model(3,i-1) = model(3,i-1) + 1;
                        end
                    end

                    if o_w == 1
                        continue;
                    else
                        val = re(o_h,o_w-1); % neighbor value
                        mu = model(1,i-1)/model(3,i-1);
                        sigma = model(2,i-1)/model(3,i-1) - mu*mu;
                        d_2 = (val-mu)*(val-mu);
                        if d_2 <= model(4,i-1);
                            flag = 1;
                        else
                            flag = 0;
                        end
                        if flag==1 && out(o_h,o_w-1)~=seed && ismember(out(o_h,o_w-1),seed_array)==0 % whether the pixel left current has same color
                            front(f_index+1,1) = o_h;
                            front(f_index+1,2) = o_w-1;
                            f_index = size(front,1);
                            out(o_h,o_w-1) = seed;
                            % update model
                            model(1,i-1) = model(1,i-1) + val;
                            model(2,i-1) = model(2,i-1) + val*val;
                            model(3,i-1) = model(3,i-1) + 1;
                        end
                    end

                end

            end

        end
    end

    %% create color
    num = size(seed_array,2); % the number of colors
    temp = out;    
    for nn=1:num    % the three loops to allocate random number for each parts in order to generate different colors
        temp(temp==nn) = rand(1);
    end
    temp = temp*100;
    r = im2uint8(temp/255);
    temp = out;
    for nn=1:num
        temp(temp==nn) = rand(1);
    end
    temp = temp*100;
    g = im2uint8(temp/255);
    temp = out;
    for nn=1:num
        temp(temp==nn) = rand(1);
    end
    temp = temp*100;
    b = im2uint8(temp/255);
    A = cat(3, r, g, b);  % combine three channels as RGB
    figure;
    imshow(A);
end

























