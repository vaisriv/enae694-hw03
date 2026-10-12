/////////////
// Imports //
/////////////
#import "@preview/adaptable-pset:0.2.0": *
#import "@preview/physica:0.9.8": *
#import "@preview/unify:0.8.1": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages)

/////////////////
// Maths Setup //
/////////////////

// upright vectors
#let vectorboldupright(a) = vb($upright(#a)$)
#let vbu = vectorboldupright
#let vectorunitupright(a) = vu($upright(#a)$)
#let vuu = vectorunitupright
#let vectorarrowupright(a) = va($upright(#a)$)
#let vau = vectorarrowupright

// automatically use square brackets for vectors and matricies
#set math.vec(delim: "[")
#set math.mat(delim: "[")
#let vecrowOld = vecrow
#let vecrow = vecrowOld.with(delim: "[")

// custom units
#add-unit("decibelIsotropic", "dBi", "upright(\"dBi\")", space: true)
#add-unit("decibelWatt", "dBW", "upright(\"dBW\")", space: true)

////////////////////
// Document Setup //
////////////////////

// assignment info
#show: homework.with(
    title: "HW03",
    author: "Vai Srivastava",
    collaborators: [],
    course-id: "ENAE694: Spacecraft Communications",
    instructor: "Prof. David Israel",
    semester: "Fall 2026",
    due-time: datetime(
        // due date
        year: 2026,
        month: 10,
        day: 12,

        // due time
        hour: 17,
        minute: 00,
        second: 00,
    ).display("[month repr:long] [day padding:zero], [year] at [hour repr:24]:[minute padding:zero]:[second padding:zero]"),

    // (defaults to A4)
    paper-size: "us-letter",
)

// document settings
#set text(font: "New Computer Modern", size: 10pt)
#set enum(numbering: "a)")

// problem headings
#let probOld = prob
#let prob = prob.with(color: black)

////////////////////////////
// The Assignment Itself: //
// Problems and Solutions //
////////////////////////////

#prob(title: [Antenna Gain and Beamwidth #emph[(30 pts.)]])[
    A circular spacecraft reflector antenna operates at $f = qty(7.50, "GHz")$, with diameter $D = qty(0.80, "m")$. Calculate peak gain directly from diameter and frequency using the formula below, which assumes aperture efficiency 0.55.

    + Calculate peak antenna gain $[G]$ in #unit("dBi") and full half-power beamwidth (HPBW) in degrees. #emph[(10 pts.)]
    <hwk:p01a>

    + Double the diameter while keeping frequency and efficiency fixed. Find the change in the gain, the new gain, and the new HPBW. #emph[(10 pts.)]
    <hwk:p01b>

    + Return to the original antenna. Double the frequency from 7.50 to #qty(15.00, "GHz") while keeping diameter and efficiency fixed. Find the change in gain and the new HPBW. Explain why this gain increase alone does not establish the change in received power for the complete link. #emph[(10 pts.)]
    <hwk:p01c>

    Use $D$ in meters and $f$ in GHz. The gain constant includes efficiency 0.55 and all unit conversions; do not apply efficiency again. HPBW is the full width in degrees. Its reflector rule is approximate and depends on illumination, not efficiency alone.

    $
        [G] = 17.81 + 20 log_10(D) + 20 log_10(f) \
        "HPBW" approx 21/(f D) "degrees"
    $
] <hwk:p01>

+ Substituting $D = qty(0.80, "m")$ and $f = qty(7.50, "GHz")$ (as plain numbers in meters and GHz) directly into the gain formula:
    $
        [G] &= 17.81 + 20 log_10(0.80) + 20 log_10(7.50) \
        &= 17.81 + (-1.9382) + 17.5012 \
        &= qty(33.3730, "dBi")
    $
    and the full half-power beamwidth is
    $
        "HPBW" approx 21/(f D) = 21/((7.50)(0.80)) = 21/6.00 = qty(3.50, "degree")
    $
    #raw(read("../outputs/text/s01a.txt"), block: true, lang: "txt")

    $
        [G] = qty(33.37, "dBi"), quad "HPBW" = qty(3.50, "degree") quad qed
    $
<hwk:s01a>

+ With $D' = 2 D = qty(1.60, "m")$ and $f$ unchanged, only the diameter term changes:
    $
        Delta [G] &= 20 log_10(D'/D) = 20 log_10(2) = qty(6.0206, "dB") \
        [G'] &= [G] + Delta [G] = 33.3730 + 6.0206 = qty(39.3936, "dBi") \
        "HPBW"' &approx 21/((7.50)(1.60)) = 21/12.00 = qty(1.75, "degree")
    $
    Doubling the aperture quadruples its area (gain $prop D^2$, so $+qty(6.02, "dB")$) and halves the beamwidth (HPBW $prop 1\/D$).
    #raw(read("../outputs/text/s01b.txt"), block: true, lang: "txt")

    $
        Delta [G] = +qty(6.02, "dB"), quad [G'] = qty(39.39, "dBi"), quad "HPBW"' = qty(1.75, "degree") quad qed
    $
<hwk:s01b>

+ With $f' = 2 f = qty(15.00, "GHz")$ and $D = qty(0.80, "m")$, only the frequency term changes:
    $
        Delta [G] &= 20 log_10(f'/f) = 20 log_10(2) = qty(6.0206, "dB") \
        [G'] &= 33.3730 + 6.0206 = qty(39.3936, "dBi") \
        "HPBW"' &approx 21/((15.00)(0.80)) = 21/12.00 = qty(1.75, "degree")
    $
    The same physical dish is now twice as large when measured in wavelengths ($D\/lambda$ doubles), so it behaves exactly like the doubled-diameter antenna in #link(<hwk:p01b>)[Part B].

    #figure(image("../outputs/figures/s01.png", width: 100%), caption: [Peak gain and HPBW versus diameter at both frequencies; cases (a)–(c) marked.])

    This gain increase alone does not establish the change in received power because received power depends on every term of the link equation,
    $
        [P_r] = [P_t] + [G_t] + [G_r] - [L_"fs"] - [L_"other"], quad [L_"fs"] = 20 log_10((4 pi R f)/c)
    $
    and several of those also change with frequency:
    - #strong[Free-space path loss] rises by the same $20 log_10(2) = qty(6.02, "dB")$ at fixed range. If the other end of the link is a fixed-#emph[gain] antenna (e.g. a low-gain or fixed-beamwidth antenna), the $+qty(6.02, "dB")$ gain is exactly cancelled and $Delta [P_r] approx qty(0, "dB")$; only if the other end is a fixed-#emph[aperture] antenna, whose gain also rises by $qty(6.02, "dB")$, does the link gain a net $+qty(6.02, "dB")$.
    - #strong[Pointing loss] grows: the beam is half as wide, so the same pointing error $theta$ costs $4 times$ the loss ($L prop (theta\/"HPBW")^2$).
    - #strong[Atmospheric and rain attenuation], surface-tolerance (Ruze) losses, and receiver noise temperature and hardware losses are generally worse at higher frequency.

    So the gain change is only one term; the received power (and $E_b\/N_0$) change must come from the complete link budget.

    $
        Delta [G] = +qty(6.02, "dB"), quad [G'] = qty(39.39, "dBi"), quad "HPBW"' = qty(1.75, "degree") quad qed
    $
<hwk:s01c>

#pagebreak(weak: true)

#prob(title: [Pointing and Polarization Loss #emph[(30 pts.)]])[
    A different link has aligned, polarization-matched received power $[P_(r_0)] = qty(-118.00, "dBW")$. The receiver requires at least #qty(-123.50, "dBW"). Transmit HPBW is #qty(3.50, "degree") with a pointing error of #qty(0.875, "degree"). Receive HPBW is #qty(1.40, "degree") with a pointing error of #qty(0.350, "degree"). Both antennas use linear polarization; their polarization axes differ by #qty(45, "degree") about the line of sight. All other losses are already included in $[P_(r_0)]$.

    + Calculate the transmit and receive pointing losses separately. #emph[(10 pts.)]
    <hwk:p02a>

    + Calculate polarization loss, actual received power, and margin above the receiver threshold. Does the link meet the threshold? #emph[(10 pts.)]
    <hwk:p02b>

    + Change only the polarization-axis difference to #qty(60, "degree"). Recalculate received power and margin. Explain why correcting polarization alignment can restore this link without changing antenna gain. #emph[(10 pts.)]
    <hwk:p02c>

    Use the following near-boresight approximation and ideal linear-polarization model. Enter $theta$ and full HPBW in the same angular units. Record losses as positive #unit("dB") values and subtract them once. The pointing approximation does not model sidelobes or nulls.

    $
        [L_("point")] = 12 (theta/"HPBW")^2 \
        [L_("pol")] = -10 log_10(cos^2(psi)) \
        [P_r] = [P_(r_0)] - [L_"pt"] - [L_"pr"] - [L_"pol"] \
        "Margin" = [P_r] - "Threshold"
    $
] <hwk:p02>

+ Using the near-boresight approximation with each antenna's own pointing error and full HPBW (both in degrees):
    $
        [L_"pt"] &= 12 ((qty(0.875, "degree"))/(qty(3.50, "degree")))^2 = 12 (0.25)^2 = qty(0.75, "dB") \
        [L_"pr"] &= 12 ((qty(0.350, "degree"))/(qty(1.40, "degree")))^2 = 12 (0.25)^2 = qty(0.75, "dB")
    $
    Both errors are one quarter of their beamwidths, so both losses are equal even though the receive beam is narrower.
    #raw(read("../outputs/text/s02a.txt"), block: true, lang: "txt")

    $
        [L_"pt"] = qty(0.75, "dB"), quad [L_"pr"] = qty(0.75, "dB") quad qed
    $
<hwk:s02a>

+ For a $psi = qty(45, "degree")$ axis difference:
    $
        [L_"pol"] &= -10 log_10(cos^2(qty(45, "degree"))) = -10 log_10(0.5) = qty(3.0103, "dB") \
        [P_r] &= [P_(r_0)] - [L_"pt"] - [L_"pr"] - [L_"pol"] \
        &= -118.00 - 0.75 - 0.75 - 3.0103 = qty(-122.5103, "dBW") \
        "Margin" &= [P_r] - "Threshold" = -122.5103 - (-123.50) = +qty(0.9897, "dB")
    $
    #raw(read("../outputs/text/s02b.txt"), block: true, lang: "txt")

    The margin is positive, so the link #strong[meets] the receiver threshold, but only by about $qty(1, "dB")$.

    $
        [L_"pol"] = qty(3.01, "dB"), quad [P_r] = qty(-122.51, "dBW"), quad "Margin" = +qty(0.99, "dB") quad qed
    $
<hwk:s02b>

+ Changing only $psi$ to $qty(60, "degree")$ (pointing losses unchanged):
    $
        [L_"pol"] &= -10 log_10(cos^2(qty(60, "degree"))) = -10 log_10(0.25) = qty(6.0206, "dB") \
        [P_r] &= -118.00 - 0.75 - 0.75 - 6.0206 = qty(-125.5206, "dBW") \
        "Margin" &= -125.5206 - (-123.50) = qty(-2.0206, "dB")
    $
    #raw(read("../outputs/text/s02c.txt"), block: true, lang: "txt")

    The margin is negative, so the link #strong[fails] the threshold.

    #figure(image("../outputs/figures/s02c.png", width: 80%), caption: [Link margin versus polarization-axis difference $psi$ (pointing losses fixed at $qty(0.75, "dB")$ each).])

    Polarization loss is a #emph[mismatch] loss: the receive antenna only couples the component of the incident field parallel to its own polarization axis, a fraction $cos^2 psi$ of the power. It does not depend on either antenna's gain, aperture, or beam pattern, and the full gain is still being delivered along the line of sight. Rotating the feed, the antenna, or the spacecraft about the line of sight to bring $psi -> qty(0, "degree")$ (or switching both ends to matched circular polarization) drives $[L_"pol"] -> qty(0, "dB")$:
    $
        [P_r] = -118.00 - 0.75 - 0.75 - 0 = qty(-119.50, "dBW"), quad "Margin" = +qty(4.00, "dB")
    $
    recovering $qty(6.02, "dB")$ and restoring the link with no change to antenna gain.

    $
        [L_"pol"] = qty(6.02, "dB"), quad [P_r] = qty(-125.52, "dBW"), quad "Margin" = qty(-2.02, "dB") quad qed
    $
<hwk:s02c>

#pagebreak(weak: true)

#prob(title: [Antenna Pointing During a Pass #emph[(20 pts.)]])[
    A spacecraft must keep its science instrument pointed at nadir while communicating continuously throughout a 12-minute overhead pass. Its fixed antenna also points at nadir. At the midpoint (6 minutes), the station lies on antenna boresight: gain is at its peak, range is shortest, and link margin is +#qty(5, "dB"). Toward either end, the station moves off boresight, gain decreases, and range increases. Use the interval approximations below; all other link-budget terms remain unchanged. The link is usable when margin is zero or greater.

    #table(
        columns: 3,
        [#strong[Time After Start of Pass]], [#strong[Fixed Antenna Gain Relative to Peak]], [#strong[Additional Path Loss]],

        [#qtyrange(0, 2, "min")], [#qty(-8, "dB")], [#qty(4, "dB")],
        [#qtyrange(2, 5, "min")], [#qty(-2, "dB")], [#qty(1, "dB")],
        [#qtyrange(5, 7, "min")], [#qty(0, "dB")], [#qty(0, "dB")],
        [#qtyrange(7, 10, "min")], [#qty(-2, "dB")], [#qty(1, "dB")],
        [#qtyrange(10, 12, "min")], [#qty(-8, "dB")], [#qty(4, "dB")],
    )

    + For the fixed antenna, calculate margin in each interval. Identify when the link is usable. Does it meet the continuous-communication requirement? #emph[(8 pts.)]
    <hwk:p03a>

    + Put the same antenna on a gimbal that tracks the station throughout the pass while the spacecraft remains nadir-pointed. Assume ideal tracking, adequate gimbal travel, and no added RF loss: antenna gain stays at its peak, but the additional path loss remains as listed. Calculate margin in each interval. Does this configuration meet the requirement? #emph[(8 pts.)]
    <hwk:p03b>

    + Explain why a gimbal is needed for this antenna to meet both requirements. Why would rotating the whole spacecraft toward the station not be an acceptable solution? #emph[(4 pts.)]
    <hwk:p03c>

    $
        "Margin" = qty(5, "dB") + "Gain"_"relative to peak" - "Additional Path Loss"
    $
    Additional path loss is relative to the pass midpoint. A gimbal changes pointing, not range. No outside research is required.
] <hwk:p03>

+ For the fixed, nadir-pointed antenna, $"Margin" = qty(5, "dB") + "Gain"_"rel" - "Additional Path Loss"$ in each interval:
    $
        qtyrange(0, 2, "min"): & quad 5 + (-8) - 4 = qty(-7, "dB") \
        qtyrange(2, 5, "min"): & quad 5 + (-2) - 1 = +qty(2, "dB") \
        qtyrange(5, 7, "min"): & quad 5 + 0 - 0 = +qty(5, "dB") \
        qtyrange(7, 10, "min"): & quad 5 + (-2) - 1 = +qty(2, "dB") \
        qtyrange(10, 12, "min"): & quad 5 + (-8) - 4 = qty(-7, "dB")
    $
    #raw(read("../outputs/text/s03a.txt"), block: true, lang: "txt")

    The link is usable (margin $>= qty(0, "dB")$) only from $qtyrange(2, 10, "min")$, i.e. $qty(8, "min")$ of the $qty(12, "min")$ pass. In the first and last $qty(2, "min")$ the station is far off boresight and the margin is $qty(-7, "dB")$, so the fixed antenna #strong[does not] meet the continuous-communication requirement.

    $
        t_"usable" = qtyrange(2, 10, "min") med (qty(8, "min")), quad "Margin"_min = qty(-7, "dB") quad qed
    $
<hwk:s03a>

+ With ideal gimbal tracking the gain stays at peak ($"Gain"_"rel" = qty(0, "dB")$); only the range-driven path loss remains:
    $
        qtyrange(0, 2, "min"): & quad 5 + 0 - 4 = +qty(1, "dB") \
        qtyrange(2, 5, "min"): & quad 5 + 0 - 1 = +qty(4, "dB") \
        qtyrange(5, 7, "min"): & quad 5 + 0 - 0 = +qty(5, "dB") \
        qtyrange(7, 10, "min"): & quad 5 + 0 - 1 = +qty(4, "dB") \
        qtyrange(10, 12, "min"): & quad 5 + 0 - 4 = +qty(1, "dB")
    $
    #raw(read("../outputs/text/s03b.txt"), block: true, lang: "txt")

    #figure(image("../outputs/figures/s03.png", width: 80%), caption: [Link margin through the pass for the fixed (nadir) and gimbaled antennas.])

    Every interval has non-negative margin (minimum $+qty(1, "dB")$ at the ends of the pass), so the gimbaled configuration #strong[meets] the continuous-communication requirement while the spacecraft stays nadir-pointed.

    $
        "Margin"_min = +qty(1, "dB") >= 0 => "continuous over" qtyrange(0, 12, "min") quad qed
    $
<hwk:s03b>

+ The fixed antenna fails only because of #emph[pointing]: at the ends of the pass the station is off boresight and the $qty(-8, "dB")$ gain loss, combined with the $qty(4, "dB")$ extra path loss, drives the margin to $qty(-7, "dB")$. Range loss alone ($qty(4, "dB")$) fits within the $qty(5, "dB")$ midpoint margin, so the only way to close the link is to keep the antenna boresight on the station. Since the antenna is rigidly aligned with the nadir-pointed body, that requires pointing either the antenna or the whole spacecraft.

    Rotating the whole spacecraft toward the station would also rotate the body-fixed science instrument off nadir for most of the pass, which violates the science-pointing requirement (the two requirements need two different pointing directions at the same time). Slewing the bus also costs attitude-control momentum or propellant, settling time and pointing stability, and can disturb thermal and solar-array geometry. A gimbal #emph[decouples] the two pointing directions: the bus stays nadir for science while the antenna tracks the station for communications. A gimbal changes pointing, not range, which is why the residual path loss in #link(<hwk:p03b>)[Part B] remains but is covered by margin.

    Gimbal decouples antenna pointing from nadir science pointing. $qed$
<hwk:s03c>

#pagebreak(weak: true)

#prob(title: [Antenna Mass and Pointing Trade #emph[(20 pts.)]])[
    Continue the spacecraft scenario from #link(<hwk:p03>)[Problem 3]. The spacecraft must maintain nadir-pointed science observations and communicate throughout the full pass. Both antenna options below have the RF performance used in #link(<hwk:p03>)[Problem 3]. The maximum installed antenna-system mass is #qty(5.0, "kg").

    #table(
        columns: 3,
        [#strong[Option]], [#strong[Complete Installed Mass]], [#strong[Pointing Capability]],

        [A: Fixed Antenna], [#qty(2.0, "kg")], [Requires spacecraft rotation to point at the station.],
        [B: Gimbaled Antenna], [#qty(6.0, "kg")], [Tracks the station while the spacecraft maintains its science attitude.]
    )

    The stated masses include the aperture, feed, supports, and any deployment or pointing mechanisms. These are supplied design assumptions, not specifications for a named mission.

    + Using your results from #link(<hwk:p03>)[Problem 3], identify which option meets the communications and science requirements. Compare each option with the mass limit. Does either meet all requirements as proposed? #emph[(8 pts.)]
    <hwk:p04a>

    + Recommend one design or requirement change that makes the mission feasible. State its cost or consequence, including any mass reallocation, hardware redesign, or reduction in communications or science performance. #emph[(6 pts.)]
    <hwk:p04b>

    + Explain why antenna mass location matters to spacecraft slewing and pointing, even when two designs have the same total mass. #emph[(6 pts.)]
    <hwk:p04c>
] <hwk:p04>

+ Using the Problem 3 results and the $qty(5.0, "kg")$ limit:
    #table(
        columns: 5,
        [#strong[Option]], [#strong[Comms (full pass)]], [#strong[Science (nadir)]], [#strong[Mass vs. limit]], [#strong[All met?]],
        [A: Fixed], [Only if the spacecraft slews (fails if nadir: $qty(-7, "dB")$ at the pass ends)], [Only if it does #emph[not] slew], [$qty(2.0, "kg") <= qty(5.0, "kg")$ ($qty(3.0, "kg")$ under)], [No],
        [B: Gimbaled], [Yes ($"Margin"_min = +qty(1, "dB")$)], [Yes], [$qty(6.0, "kg") > qty(5.0, "kg")$ ($qty(1.0, "kg")$, $qty(20, "%")$ over)], [No],
    )
    #raw(read("../outputs/text/s04a.txt"), block: true, lang: "txt")

    Option A fits the mass limit but cannot satisfy communications and science at the same time: nadir-pointed it has only $qty(8, "min")$ of usable link, and slewing to close the link breaks the science attitude. Option B meets both the communications and science requirements but exceeds the mass limit by $qty(1.0, "kg")$. #strong[Neither option meets all requirements as proposed.]

    $
        m_B - m_max = 6.0 - 5.0 = qty(1.0, "kg") "over" quad qed
    $
    A cannot meet comms and science together.
<hwk:s04a>

+ #strong[Recommendation:] select Option B (gimbaled) and raise the antenna-system mass allocation from $qty(5.0, "kg")$ to $qty(6.0, "kg")$ by reallocating $qty(1.0, "kg")$ from the spacecraft's system-level mass margin (or from another subsystem's allocation). This is the only option that keeps both full-pass communications and continuous nadir science with no performance reduction, and the shortfall is a single, modest $qty(1.0, "kg")$.

    #strong[Cost and consequences:]
    - Mass reallocation: system mass margin drops by $qty(1.0, "kg")$, leaving less reserve for later growth, or another subsystem must be lightened or descoped (e.g. less propellant, structure or battery mass), which may itself cost lifetime or capability. The change must be approved through the mass budget/requirements process.
    - Hardware: a gimbal adds a mechanism (actuators, drive electronics, harness, cable wrap or rotary joint), a single-point-failure risk, power consumption, extra test and qualification, and cost.
    - Attitude control: gimbal motion produces reaction torques and jitter that the ACS must absorb while holding nadir.
    - Performance: with ideal tracking, communications keep at least $+qty(1, "dB")$ margin through the pass, and science pointing is unaffected.

    $
        m_"alloc"' = qty(5.0, "kg") + qty(1.0, "kg") = qty(6.0, "kg") >= m_B quad qed
    $
<hwk:s04b>

+ Slewing and pointing depend on the spacecraft's #emph[inertia] and #emph[center of mass], not just its total mass. For a mass $m$ at distance $r$ from the rotation axis, the moment of inertia is
    $
        I = sum_i m_i r_i^2, quad tau = I alpha, quad H = I omega
    $
    so the same $qty(6.0, "kg")$ placed on a boom $qty(1, "m")$ from the center of mass adds about $qty(6, "kg m^2")$, while the same mass mounted close to the center adds almost nothing. Consequently:
    - #strong[Slewing:] larger $I$ requires more torque for the same angular acceleration, or more time and stored momentum ($H = I omega$) for the same slew rate, driving larger reaction wheels, more momentum dumping, and more power or propellant.
    - #strong[Center-of-mass offset:] an off-axis antenna shifts the center of mass, adding disturbance torques (gravity gradient, solar pressure, drag, thruster misalignment) that the ACS must counter continuously.
    - #strong[Cross-coupling:] asymmetric mass creates products of inertia, so a commanded rotation about one axis induces motion about others.
    - #strong[Moving mass and flexibility:] a gimbaled or boom-mounted antenna moves mass relative to the bus, producing reaction torques and lower-frequency structural modes that cause jitter and degrade the fine pointing of both the antenna and the science instrument.

    Two designs with equal total mass can therefore have very different slew times, actuator sizing, and pointing stability.

    $I = sum_i m_i r_i^2$ depends on mass location, not just total mass. $qed$
<hwk:s04c>

#pagebreak(weak: true)

== Code

#codly(header: [./src/index.py])
#raw(read("../src/index.py"), block: true, lang: "python") <code:index.py>
