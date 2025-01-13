include("tools.jl")
include("sigproc.jl")

# Время задержки отображения графиков
sleep_time = 1.0

# Период дискретизации и ось времени
sample_t = 0.001
t = 0:sample_t:6

# Имитация реального сигнала
rr_freq = 20.0
rr_atten = 30.0
rr_len = 0.5
real_ref = makerefsig(t, rr_len, rr_freq, rr_atten)
display(plot(real_ref, label="real_ref"))
sleep(sleep_time)

# Имитация рабочей записи сигналов с различными амплитудами
signal_amps = [1.0, 0.3, 0.2, 0.1]
record = zeros(length(t))
for i in 1:length(signal_amps)
	insertsig!(record, real_ref*signal_amps[i], i*1000)
end
display(plot(record, label="record"))
sleep(sleep_time)

# Определим размах полезного сигнала.
rr_pp = calcpp(real_ref)

# Добавим шум.
# Макс амплитуда не более 10% от наибольшего полезного сигнала.
# Гармоники на частотах от 5 до 100 Гц.
record .+= harmnoise(t, 5:100, pp=0.1*rr_pp)
display(plot(record, label="noisy record", title="Noisy record"))
sleep(sleep_time)

# Всё готово для теста алгоритма детектирования
# ---------------------------------------------

# По начальному участку записи определить пиковые значения шумов
noise_pp = calcpp(record[1:500])

# Запустить функцию определения параметров опорного сигнала
synth_ref_freq, synth_ref_atten, _ = calcrefparams(record, noise_pp, sample_t)

# Смоделировать опорный сигнал
synth_ref = makerefsig(t, rr_len, synth_ref_freq, synth_ref_atten)

# Выполнить корреляцию записи с синтетическим опорным сигналом
cor_rec = makecor(record, synth_ref)

# Обрежем исходную запись до длины коррелированной
resize!(record, length(cor_rec))

# Посмотрим графики
display(plot([record cor_rec], title="After correlation",
			label=["original" "correlated"], layout=(2,1)))
sleep(sleep_time*2)

display(plot([record cor_rec], title="SNR = 3", 
			label=["original" "correlated"],
			layout=(2,1), xlims=(1800, 2200)))
sleep(sleep_time*2)

display(plot([record cor_rec], title="SNR = 1.5",
			label=["original" "correlated"], 
			layout=(2,1), xlims=(2800, 3200)))
sleep(sleep_time*2)

display(plot([record cor_rec], title="SNR = 1",
			label=["original" "correlated"],
			layout=(2,1), xlims=(3800, 4200)))
sleep(sleep_time*2)

display(plot([record cor_rec], title="SNR = 1.5",
			label=["original" "correlated"], 
			layout=(2,1), xlims=(2900, 3100)))
sleep(sleep_time*2)

