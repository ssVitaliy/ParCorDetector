function findextrems(arr, trig_level; half_win=4, max_cnt=3)
	
	pos = Int[]
	pos_num = 1
	max_val = 0
	cur_pos = 0
	dir = 1
	trig_level *= 2*half_win + 1

	for x in 1+half_win:length(arr)-half_win	
		winsum = sum(arr[x-half_win:x+half_win])-dir*trig_level
		if abs(winsum) > 0
			if dir*winsum > dir*max_val
				max_val = winsum
				cur_pos = x
			elseif abs(winsum) < 0.7*abs(max_val)
				push!(pos, cur_pos)
				pos_num+=1
				max_val = 0
				dir *= -1
			end
		end
		if pos_num > max_cnt
			break
		end
		if pos_num > 2 && x - pos[end] > 2*(pos[2] - pos[1])
			break
		end 
	end
	return pos
end

function periodbyextrems(extrems, time_step)
    hp_num = length(extrems)-1 # Number of half-periods

    #hp_time - Median time of 1 half-period
    hp_time = sum([extrems[i+1]-extrems[i] for i in 1:hp_num])/hp_num

    # Return signal period
    time_step*2*hp_time
end

function calcattenuation(
			sig::Vector,
			extrems::Vector,
			time_step::Real
		)::Float64

	t1 = extrems[1]
	t2 = extrems[2]
	
	amp_ratio = abs(sig[t2]/sig[t1])
	return -1*log(amp_ratio) / ((t2-t1)*time_step)
end

function getstartpoint(extrems::Vector)::Int
	half_per_num = length(extrems)-1
	half_per = sum([extrems[i+1]-extrems[i] for i in 1:half_per_num]) /
				half_per_num
	round(Int, extrems[1] - half_per/2, RoundUp)
end

function calcrefparams(sig, trig_level, time_step)
	extrems = findextrems(sig, trig_level)
	period = periodbyextrems(extrems, time_step)
	atten = calcattenuation(sig, extrems, time_step)
	start_point = getstartpoint(extrems)

	return (1/period, atten, start_point)
	end
