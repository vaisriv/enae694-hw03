import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# repository root (./submission.py is a symlink to ./src/index.py)
ROOT = os.path.dirname(os.path.abspath(__file__))
if os.path.basename(ROOT) == "src":
    ROOT = os.path.dirname(ROOT)

# plot styling
SERIES = ["#2a78d6", "#eb6834", "#1baf7a"]
INK = "#52514e"
plt.rcParams.update(
    {
        "figure.dpi": 150,
        "font.family": "serif",
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.edgecolor": INK,
        "axes.labelcolor": "#0b0b0b",
        "axes.grid": True,
        "grid.color": "#e4e3df",
        "grid.linewidth": 0.6,
        "xtick.color": INK,
        "ytick.color": INK,
        "lines.linewidth": 2,
    }
)


def heading(problem):
    print(f"\n------\n {problem}\n------")


def save_text(name, text):
    print(text)
    with open(os.path.join(ROOT, "outputs/text", f"{name}.txt"), "w", encoding="utf-8") as f:
        f.write(text + "\n")


def save_fig(fig, name):
    fig.tight_layout()
    fig.savefig(os.path.join(ROOT, "outputs/figures", f"{name}.png"))
    plt.close(fig)


# p01: antenna gain [dBi] and full HPBW [deg] (D in m, f in GHz)
def gain_db(D, f):
    return 17.81 + 20 * np.log10(D) + 20 * np.log10(f)


def hpbw(D, f):
    return 21 / (f * D)


# p02: pointing and polarization losses [dB]
def pointing_loss(theta, bw):
    return 12 * (theta / bw) ** 2


def pol_loss(psi_deg):
    return -10 * np.log10(np.cos(np.radians(psi_deg)) ** 2)


def main():
    os.makedirs(os.path.join(ROOT, "outputs/text"), exist_ok=True)
    os.makedirs(os.path.join(ROOT, "outputs/figures"), exist_ok=True)

    #########
    # p01 #
    #########
    heading("p01")

    D0, f0 = 0.80, 7.50

    # a) original antenna
    G_a, bw_a = gain_db(D0, f0), hpbw(D0, f0)
    save_text(
        "s01a",
        f"D = {D0:.2f} m, f = {f0:.2f} GHz\n"
        f"20 log10(D) = {20 * np.log10(D0):.4f} dB\n"
        f"20 log10(f) = {20 * np.log10(f0):.4f} dB\n"
        f"[G]  = {G_a:.4f} dBi ~ {G_a:.2f} dBi\n"
        f"HPBW = {bw_a:.4f} deg ~ {bw_a:.2f} deg",
    )

    # b) doubled diameter
    G_b, bw_b = gain_db(2 * D0, f0), hpbw(2 * D0, f0)
    save_text(
        "s01b",
        f"D = {2 * D0:.2f} m, f = {f0:.2f} GHz\n"
        f"d[G] = 20 log10(2) = {G_b - G_a:.4f} dB ~ {G_b - G_a:.2f} dB\n"
        f"[G]  = {G_b:.4f} dBi ~ {G_b:.2f} dBi\n"
        f"HPBW = {bw_b:.4f} deg ~ {bw_b:.2f} deg",
    )

    # c) doubled frequency
    G_c, bw_c = gain_db(D0, 2 * f0), hpbw(D0, 2 * f0)
    save_text(
        "s01c",
        f"D = {D0:.2f} m, f = {2 * f0:.2f} GHz\n"
        f"d[G] = 20 log10(2) = {G_c - G_a:.4f} dB ~ {G_c - G_a:.2f} dB\n"
        f"[G]  = {G_c:.4f} dBi ~ {G_c:.2f} dBi\n"
        f"HPBW = {bw_c:.4f} deg ~ {bw_c:.2f} deg\n"
        f"d[L_fs] = 20 log10(2) = {20 * np.log10(2):.4f} dB (free-space loss also rises)",
    )

    # gain and HPBW vs diameter (two charts, one axis each)
    D = np.linspace(0.3, 2.0, 200)
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(9, 3.6))
    for i, f in enumerate([f0, 2 * f0]):
        ax1.plot(D, gain_db(D, f), color=SERIES[i], label=f"f = {f:.2f} GHz")
        ax2.plot(D, hpbw(D, f), color=SERIES[i], label=f"f = {f:.2f} GHz")
    cases = [("a", D0, f0), ("b", 2 * D0, f0), ("c", D0, 2 * f0)]
    for name, Dc, fc in cases:
        for ax, y in [(ax1, gain_db(Dc, fc)), (ax2, hpbw(Dc, fc))]:
            ax.plot(Dc, y, "o", ms=7, color="#0b0b0b", mec="white", mew=1.5, zorder=3)
            ax.annotate(f"({name})", (Dc, y), xytext=(7, 4), textcoords="offset points", color=INK)
    ax1.set(xlabel="Diameter D [m]", ylabel="Peak gain [G] [dBi]", title="Peak gain")
    ax2.set(xlabel="Diameter D [m]", ylabel="HPBW [deg]", title="Half-power beamwidth")
    ax1.legend(frameon=False)
    save_fig(fig, "s01")

    #########
    # p02 #
    #########
    heading("p02")

    Pr0, thresh = -118.00, -123.50
    bw_t, th_t = 3.50, 0.875
    bw_r, th_r = 1.40, 0.350

    # a) pointing losses
    L_pt, L_pr = pointing_loss(th_t, bw_t), pointing_loss(th_r, bw_r)
    save_text(
        "s02a",
        f"[L_pt] = 12 ({th_t} / {bw_t})^2 = {L_pt:.4f} dB\n"
        f"[L_pr] = 12 ({th_r} / {bw_r})^2 = {L_pr:.4f} dB",
    )

    # b), c) polarization loss, received power, margin
    def link(psi):
        L_pol = pol_loss(psi)
        Pr = Pr0 - L_pt - L_pr - L_pol
        return L_pol, Pr, Pr - thresh

    for part, psi in [("b", 45), ("c", 60)]:
        L_pol, Pr, M = link(psi)
        save_text(
            f"s02{part}",
            f"psi     = {psi} deg\n"
            f"[L_pol] = {L_pol:.4f} dB\n"
            f"[P_r]   = {Pr:.4f} dBW ~ {Pr:.2f} dBW\n"
            f"Margin  = {M:.4f} dB ~ {M:.2f} dB -> {'meets' if M >= 0 else 'fails'} threshold",
        )
    _L_pol0, Pr0_al, M0 = link(0)
    print(f"aligned (psi = 0): [P_r] = {Pr0_al:.2f} dBW, Margin = {M0:.2f} dB")

    # margin vs polarization mismatch
    psi = np.linspace(0, 80, 400)
    fig, ax = plt.subplots(figsize=(6.5, 3.6))
    ax.plot(psi, link(psi)[2], color=SERIES[0])
    ax.axhline(0, color=INK, lw=1, ls="--")
    ax.annotate("threshold", (2, 0), xytext=(0, 4), textcoords="offset points", color=INK)
    for p in [0, 45, 60]:
        M = link(p)[2]
        ax.plot(p, M, "o", ms=7, color=SERIES[0], mec="white", mew=1.5, zorder=3)
        ax.annotate(f"{p}°: {M:+.2f} dB", (p, M), xytext=(6, 6), textcoords="offset points", color="#0b0b0b")
    ax.set_ylim(top=5.5)
    ax.set(xlabel=r"Polarization-axis difference $\psi$ [deg]", ylabel="Margin [dB]", title="Link margin vs polarization mismatch")
    save_fig(fig, "s02c")

    #########
    # p03 #
    #########
    heading("p03")

    intervals = pd.DataFrame(
        {
            "start": [0, 2, 5, 7, 10],
            "end": [2, 5, 7, 10, 12],
            "gain_rel": [-8, -2, 0, -2, -8],
            "path_loss": [4, 1, 0, 1, 4],
        }
    )
    intervals["interval"] = [f"{s}-{e} min" for s, e in zip(intervals.start, intervals.end)]

    # a) fixed antenna; b) gimbaled antenna (gain held at peak)
    intervals["fixed"] = 5 + intervals.gain_rel - intervals.path_loss
    intervals["gimbal"] = 5 + 0 - intervals.path_loss

    for part, col in [("a", "fixed"), ("b", "gimbal")]:
        tab = intervals[["interval", "gain_rel", "path_loss", col]].copy()
        if col == "gimbal":
            tab["gain_rel"] = 0
        tab["usable"] = np.where(tab[col] >= 0, "yes", "no")
        tab.columns = ["Interval", "Gain rel. [dB]", "Add. loss [dB]", "Margin [dB]", "Usable"]
        usable = (intervals[col] >= 0) * (intervals.end - intervals.start)
        save_text(
            f"s03{part}",
            tab.to_string(index=False)
            + f"\n\nusable time = {usable.sum()} of 12 min -> "
            + ("continuous" if usable.sum() == 12 else "NOT continuous"),
        )

    fig, ax = plt.subplots(figsize=(6.5, 3.6))
    edges = np.r_[intervals.start, 12]
    for i, (col, lbl) in enumerate([("gimbal", "Gimbaled"), ("fixed", "Fixed (nadir)")]):
        ax.step(edges, np.r_[intervals[col], intervals[col].iloc[-1]], where="post", color=SERIES[i], label=lbl)
    ax.axhline(0, color=INK, lw=1, ls="--")
    ax.annotate("usable (margin ≥ 0)", (0.2, 0), xytext=(0, 4), textcoords="offset points", color=INK)
    ax.set(xlabel="Time after start of pass [min]", ylabel="Margin [dB]", title="Link margin during the pass", xticks=edges, xlim=(0, 12))
    ax.legend(frameon=False, loc="lower center")
    save_fig(fig, "s03")

    #########
    # p04 #
    #########
    heading("p04")

    m_max = 5.0
    options = pd.DataFrame(
        {
            "Option": ["A: Fixed", "B: Gimbaled"],
            "Mass [kg]": [2.0, 6.0],
            "Comms (nadir)": ["no", "yes"],
            "Science": ["only if no slew", "yes"],
        }
    )
    options["Excess [kg]"] = options["Mass [kg]"] - m_max
    options["Mass OK"] = np.where(options["Mass [kg]"] <= m_max, "yes", "no")
    save_text(
        "s04a",
        options.to_string(index=False)
        + f"\n\nmass limit = {m_max:.1f} kg; B exceeds by {options['Excess [kg]'][1]:.1f} kg"
        + f" ({100 * options['Excess [kg]'][1] / m_max:.0f}% of the limit)",
    )


if __name__ == "__main__":
    main()
