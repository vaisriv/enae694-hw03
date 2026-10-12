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

    + Return to the original antenna. Double the frequency from 7.50 to #qty(15.00, "GHz") while keeping diameter and efficiency fixed. Find the change in gain and the new HPBW. Explain why this frequency increase alone does not establish the change in recieved power for the complete link. #emph[(10 pts.)]
    <hwk:p01c>

    Use $D$ in meters and $f$ in GHz. The gain constant includes efficiency 0.55 and all unit conversions; do not apply efficiency again. HPBW is the full width in degrees. Its reflector rule is approximate and depends on illumination, not efficiency alone.

    $
        [G] = 17.81 + 20 log_10(D) + 20 log_10(f) \
        "HPBW" approx 21/(f D) "degrees"
    $
] <hwk:p01>

// TODO: Answer
+ Answer
<hwk:s01a>

// TODO: Answer
+ Answer
<hwk:s01b>

// TODO: Answer
+ Answer
<hwk:s01c>

#pagebreak(weak: true)

#prob(title: [Pointing and Polarization Loss #emph[(30 pts.)]])[
    A different link has aligned, polarization-matched recieved power $[P_(r_0)] = qty(-118.00, "dBW")$. The reciever requires at least #qty(-123.50, "dBW"). Transmit HPBW is #qty(3.50, "degree") with a pointing error of #qty(0.875, "degree"). Recieve HPBW is #qty(1.40, "degree") with a pointing error of #qty(0.350, "degree"). Both antennas use linear polarization; their polarization axes differ by #qty(45, "degree") about the line of sight. All other losses are already included in $[P_(r_0)]$.

    + Calculate the transmit and recieve pointing losses separately. #emph[(10 pts.)]
    <hwk:p02a>

    + Calculate polarization loss, actual recieved power, and margin above the reciever threshold. Does the link meet the threshold? #emph[(10 pts.)]
    <hwk:p02b>

    + Change only the polarization-axis difference to #qty(60, "degree"). Recalculate recieved power and margin. Explain why correction polarization alignment can restore this link without changing antenna gain. #emph[(10 pts.)]
    <hwk:p02c>

    Use the following near-boresight approximation and ideal linear-polarization model. Enter $theta$ and full HPBW in the same angular units. Record losses as positive #unit("dB") values and subtract them once. The pointing approximation does not model sidelobes or nulls.

    $
        [L_("point")] = 12 (theta/"HPBW")^2 \
        [L_("pol")] = -10 log_10(cos^2(phi)) \
        [P_r] = [P_(r_0)] - [L_"pt"] - [L_"pr"] - [L_"pol"] \
        "Margin" = [P_r] - "Threshold"
    $
] <hwk:p02>

// TODO: Answer
+ Answer
<hwk:s02a>

// TODO: Answer
+ Answer
<hwk:s02b>

// TODO: Answer
+ Answer
<hwk:s02c>

#pagebreak(weak: true)

#prob(title: [Antenna Pointing During a Pass #emph[(20 pts.)]])[
    A spacecraft must keep its science instrument pointed at nadir while communicating continuously throughout a 12 minute overhead pass. Its fixed antenna also points at nadir. At the midpoint (6 minutes), the station lies on antenna boresight: gain is at its peak, range is shortest, and link margin is +#qty(5, "dB"). Toward eaither end, the station moves off boresight, gain decreases, and range increases. Use the interval approximations below; all other link-budget terms remain unchanged. The link is usable when margin is zero or greater.

    #table(
        columns: 3,
        [#strong[Time After Start of Pass]], [#strong[Fixed Antenna Gain Relative to Peak]], [#strong[Additional Path Loss]],

        [#qtyrange(0, 2, "min")], [#qty(-8, "dB")], [#qty(4, "dB")],
        [#qtyrange(2, 5, "min")], [#qty(-2, "dB")], [#qty(1, "dB")],
        [#qtyrange(5, 7, "min")], [#qty(0, "dB")], [#qty(0, "dB")],
        [#qtyrange(7, 10, "min")], [#qty(-2, "dB")], [#qty(1, "dB")],
        [#qtyrange(10, 12, "min")], [#qty(-8, "dB")], [#qty(4, "dB")],
    )

    + For the fixed antenna, calculate margin in each interval. Identify when the link is usable. Does it meet the continuous communication requirement? #emph[(8 pts.)]
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

// TODO: Answer
+ Answer
<hwk:s03a>

// TODO: Answer
+ Answer
<hwk:s03b>

// TODO: Answer
+ Answer
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

    + Using your results from #link(<hwk:p03>)[Problem 3], identify which option meet sthe communications and science requirements. Compare each option with the mass limit. Does either meet all requirements as proposed? #emph[(8 pts.)]
    <hwk:p04a>

    + Recommend one design or requirement change that makes the mission feasible. State its cost or consequence, including any mass reallocation, hardware redesign, or reduction in communications or science performance. #emph[(6 pts.)]
    <hwk:p04b>

    + Explain why antenna mass location matters to spacecraft slewing and pointing, even when two designs have the same total mass. #emph[(6 pts.)]
    <hwk:p04c>
] <hwk:p04>

// TODO: Answer
+ Answer
<hwk:s04a>

// TODO: Answer
+ Answer
<hwk:s04b>

// TODO: Answer
+ Answer
<hwk:s04c>

#pagebreak(weak: true)

== Code

#codly(header: [./src/index.py])
#raw(read("../src/index.py"), block: true, lang: "python") <code:index.py>
