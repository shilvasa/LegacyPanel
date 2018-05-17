function Legacy_CalcArSeq(a, p, n)
    return a * n + (n * (n - 1) * p) / 2;
end

function Legacy_ArithmeticSum(f, d, n)
	return n * f + n * (n - 1) * d / 2;
end

function Legacy_ArithmeticProgression(f, d, n)
	return f + (n - 1) * d;
end

function Legacy_AddPct(v, p)
	return v + v * p / 100;
end

function Legacy_QBenefit(limiter, deno, value)
	return limiter * value / (deno + value);
end

function Legacy_LeveledMod(v, a, e)
	if (v <= 0 or a <= 0 or e <= 0) then
		return 0;
	end
	
	local an = v / a;
	local blocked = 0;
	
	for i = 0, 9 do
		if (an <= i) then
			return blocked;
		end
		
		blocked = blocked + math.min(v, a * e * math.pow(0.5, i));
	end
	
	return blocked;
end
