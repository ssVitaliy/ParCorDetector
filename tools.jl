function make_ref_sig(
		time_base::AbstractRange,
		len_sec::Union{AbstractFloat, Int},
		freq::Float64=20.0,
		attenuation::Float64=20.0
	)::Vector{Float64}

	len_discrete = floor(Int, len_sec / step(time_base))
	Float64[sin(2pi*freq*t) * exp(-t*attenuation)
				for t in time_base[1:len_discrete]] 
end

function insert_sig!(dist_sig::Vector, ref::Vector, pos::Int)
	dist_sig[pos:pos+length(ref)-1]+=ref
end

function calc_rms(seq::Vector)::Float64
	sqrt(sum(seq.^2)/length(seq))
end

function calc_pp(arr::Vector)::Float64
	a,b = extrema(arr)
	b-a	
end

# Generate random WaveNoise
function harm_noise(
		time_base::AbstractRange,
		freq_range::Union{AbstractVector, Tuple};
		rms::Union{Integer, AbstractFloat}=0,
		pp::Union{Integer, AbstractFloat}=0,
		harm_count::Int=0,
		harm_deviation::AbstractFloat=1.0
	)

	if harm_count==0
		harm_count = length(freq_range)
	end
	println("harms: $harm_count")
	s1 = zeros(length(time_base))
	for i in 1:harm_count
	   fr = randn()*harm_deviation + rand(freq_range)
	   phi = rand() * 360
	   s1 += 0.2rand()*sin.(2pi * fr * t .+ phi)
	   end
	
	if rms != 0
		current_rms = sqrt(sum(s1.^2) / length(s1))
		s1 .*= rms/current_rms
	elseif pp !=0
		current_pp = maximum(s1) - minimum(s1)
		s1 .*= pp/current_pp
		end
	return s1
	end

function mrand!(arr::Vector, k::Real)
# Add uniform noise with multiplier k
	arr .+= @. k*(rand()-0.5)
end

