# -*- coding: utf-8 -*-
"""
M&B veterancy table builder (temporary tool).
Walks every *_unit.bp in the mod, replicates the engine's veterancy model:
  - COST  = V[role][tech] mass thresholds (Blueprints.lua ModBlueprints), computed
            by replicating Classify(); NOT read from the static Veteran block
            (that block is a placeholder overwritten at runtime).
  - BONUS = bp.Buffs.Regen / bp.Buffs.Health per level; if absent, the engine
            default (Regen +2/4/6/8/10, Health x1.1..1.5).
Outputs Markdown + CSV to the Desktop.
All comments in English per project convention.
"""
import os
import re
import csv

MOD_ROOT = r"F:\Games\steam\steamapps\common\Supreme Commander Forged Alliance\mods\M&B"
DESKTOP  = r"C:\Users\admin\Desktop"
OUT_MD   = os.path.join(DESKTOP, "M&B_Veterancy_Table.txt")
OUT_CSV  = os.path.join(DESKTOP, "M&B_Veterancy_Table.csv")

# ---- V[role][tech] = {L1,L2,L3,L4,L5} (mass). tech 0..4. commander/subcommander flat. ----
V = {
    "commander":     [1200, 2600, 4800, 7600, 12800],
    "subcommander":  [1000, 2200, 3800, 6600, 9200],
    "light":         {0:[20,40,60,80,100], 1:[40,80,120,160,200], 2:[60,120,180,240,300], 3:[80,160,240,320,400], 4:[160,320,480,640,800]},
    "med":           {1:[60,120,180,240,300], 2:[80,160,240,320,400], 3:[120,240,360,480,600], 4:[180,360,540,720,900]},
    "heavy":         {1:[90,180,270,360,450], 2:[120,240,360,480,600], 3:[160,320,480,640,800], 4:[180,360,540,720,900]},
    "mobile_arty":   {1:[120,240,360,480,600], 2:[240,480,720,960,1200], 3:[320,640,960,1280,1600], 4:[600,1200,1800,2400,3000]},
    "mobile_rocket": {2:[320,640,960,1280,1600], 3:[500,750,1000,1250,1500], 4:[600,1200,1800,2400,3000]},
    "mobile_aa":     {1:[240,480,720,960,1200], 2:[320,640,960,1280,1600], 3:[400,800,1200,1400,1800], 4:[400,800,1200,1400,1800]},
    "light_turret":  {1:[60,120,180,240,300], 2:[80,160,240,320,400], 3:[120,240,360,480,600], 4:[120,240,360,480,600]},
    "heavy_turret":  {1:[90,180,270,360,450], 2:[120,240,360,480,600], 3:[160,320,480,640,800], 4:[160,320,480,640,800]},
    "static_aa":     {1:[240,480,720,960,1200], 2:[240,480,720,960,1200], 3:[400,800,1200,1400,1800]},
    "longrange_arty":{1:[250,500,750,1000,1250], 2:[500,750,1000,1250,1500], 3:[2500,5000,7500,10000,12500]},
    "rapid_arty":    {1:[250,500,750,1000,1250], 2:[500,750,1000,1250,1500], 3:[2500,5000,7500,10000,12500]},
    "tactical_missile":{2:[2500,5000,7500,10000,12500]},
    "exp_turret":    {4:[2500,5000,7500,10000,12500]},
    "experimental":  {1:[250,500,750,1000,1250], 2:[500,750,1000,1250,1500], 3:[2500,5000,7500,10000,12500], 4:[5000,10000,15000,20000,25000]},
    "light_fighter": {1:[240,480,720,960,1200], 2:[320,640,960,1280,1600], 3:[400,800,1200,1400,1800]},
    "heavy_fighter": {1:[320,640,960,1280,1600], 2:[400,800,1200,1400,1800], 3:[500,750,1000,1250,1500]},
    "interceptor":   {1:[240,480,720,960,1200], 2:[320,640,960,1280,1600], 3:[400,800,1200,1400,1800]},
    "assault":       {1:[90,180,270,360,450], 2:[120,240,360,480,600], 3:[160,320,480,640,800]},
    "bomber":        {1:[320,640,960,1280,1600], 2:[500,1000,1500,2000,2500], 3:[2500,5000,7500,10000,12500]},
    "air_torpedo":   {1:[320,640,960,1280,1600], 2:[500,1000,1500,2000,2500], 3:[2500,5000,7500,10000,12500]},
    "frigate":       {1:[320,640,960,1280,1600]},
    "submarine":     {1:[400,800,1200,1600,2000], 2:[500,1000,1500,2000,2500], 3:[2500,5000,7500,10000,12500]},
    "artyship":      {2:[1000,2000,3000,4000,5000]},
    "destroyer":     {2:[500,1000,1500,2000,2500]},
    "cruiser":       {2:[500,1000,1500,2000,2500]},
    "battleship":    {3:[2500,5000,7500,10000,12500]},
    "battlecruiser": {3:[2500,5000,7500,10000,12500]},
    "carrier":       {3:[2500,5000,7500,10000,12500]},
}
VID = {"xeb2402": [2500,5000,7500,10000,12500]}
DEF_REGEN  = [2,4,6,8,10]
DEF_HEALTH = [1.1,1.2,1.3,1.4,1.5]

ROLE_RU = {
    "commander":"Командир (ACU)","subcommander":"Субкомандир (SACU)",
    "light":"Лёгкий","med":"Средний","heavy":"Тяжёлый",
    "mobile_arty":"Мобильная арта","mobile_rocket":"Мобильные ракеты","mobile_aa":"Мобильная ПВО",
    "light_turret":"Лёгкая турель","heavy_turret":"Тяжёлая турель","static_aa":"Стационарная ПВО",
    "longrange_arty":"Дальнобойная арта","rapid_arty":"Скорострельная арта",
    "tactical_missile":"Тактические ракеты","exp_turret":"Экспериментальная турель",
    "experimental":"Экспериментальный",
    "light_fighter":"Лёгкий истребитель","heavy_fighter":"Тяжёлый истребитель",
    "interceptor":"Перехватчик","assault":"Штурмовик","bomber":"Бомбардировщик","air_torpedo":"Торпедоносец",
    "frigate":"Фрегат","submarine":"Подлодка","artyship":"Арткорабль","destroyer":"Эсминец",
    "cruiser":"Крейсер","battleship":"Линкор","battlecruiser":"Линейный крейсер","carrier":"Авианосец",
}

def lua_lower(s):
    """Lua string.lower lowercases ASCII A-Z only (leaves Russian bytes). Replicate."""
    return "".join(chr(ord(c)+32) if "A" <= c <= "Z" else c for c in s)

def find_block(text, key):
    """Find a top-level (4-space indent) `key = {` and return the balanced inner text."""
    m = re.search(r"(?m)^    " + re.escape(key) + r"\s*=\s*\{", text)
    if not m:
        return None
    i = m.end() - 1  # position of opening brace
    depth = 0
    j = i
    while j < len(text):
        c = text[j]
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return text[i+1:j]
        j += 1
    return None

def parse_categories(text):
    blk = find_block(text, "Categories")
    if blk is None:
        return []
    return re.findall(r"'([^']*)'", blk)

def parse_subblock_vals(block, subkey):
    """Within a Buffs block, find `subkey = { Level1=.. Level5=.. }` -> list of 5."""
    if block is None:
        return None
    m = re.search(re.escape(subkey) + r"\s*=\s*\{", block)
    if not m:
        return None
    i = m.end() - 1
    depth = 0; j = i
    inner = None
    while j < len(block):
        c = block[j]
        if c == "{": depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                inner = block[i+1:j]; break
        j += 1
    if inner is None:
        return None
    vals = []
    for n in range(1, 6):
        mm = re.search(r"Level" + str(n) + r"\s*=\s*(-?[0-9.]+)", inner)
        vals.append(mm.group(1) if mm else "?")
    return vals

def parse_field_str(text, key):
    m = re.search(r"(?m)^    " + re.escape(key) + r"\s*=\s*'((?:[^'\\]|\\.)*)'", text)
    return m.group(1) if m else None

def parse_unitname(text):
    # UnitName lives inside the General block (8-space indent); scope the search there.
    g = find_block(text, "General") or text
    m = re.search(r"UnitName\s*=\s*'((?:[^'\\]|\\.)*)'", g)
    return m.group(1) if m else None

def parse_scalar(text, key):
    m = re.search(r"\b" + re.escape(key) + r"\s*=\s*(-?[0-9.]+)", text)
    return m.group(1) if m else None

def classify(desc_raw, cats):
    catset = set(cats)
    if "SUBCOMMANDER" in catset: return "subcommander", None
    if "COMMAND" in catset: return "commander", None
    s = desc_raw or ""
    p = s.find(">")
    if p >= 0: s = s[p+1:]
    s = s.replace("ё", "е").replace("Ё", "Е")
    sLow = lua_lower(s)
    tech = None
    tm = re.search(r"t([0-9])", sLow)
    if tm: tech = int(tm.group(1))
    elif "TECH4" in catset: tech = 4
    elif "TECH3" in catset: tech = 3
    elif "TECH2" in catset: tech = 2
    elif "TECH1" in catset: tech = 1
    def Has(sub): return sub in s
    def HasL(sub): return sub in sLow
    if "EXPERIMENTAL" in catset:
        if "STRUCTURE" in catset: return "exp_turret", (tech or 4)
        return "experimental", (tech or 4)
    if "STRUCTURE" in catset:
        if "ANTIAIR" in catset: return "static_aa", tech
        if Has("тактич") or HasL("tactical") or HasL("missile"): return "tactical_missile", tech
        if Has("орудие") or HasL("turret") or HasL("point defense"):
            if Has("Тяжел") or HasL("heavy"): return "heavy_turret", tech
            return "light_turret", tech
        if Has("арта") or Has("артилл") or HasL("artillery"):
            if Has("скорострельная") or HasL("rapid"): return "rapid_arty", tech
            return "longrange_arty", tech
        return None, None
    if "AIR" in catset:
        if Has("торпедник") or HasL("torpedo"): return "air_torpedo", tech
        if Has("бомбардировщик") or HasL("bomber"): return "bomber", tech
        if Has("штурмовик") or HasL("gunship") or HasL("assault"): return "assault", tech
        if Has("перехватчик") or HasL("interceptor"): return "interceptor", tech
        if Has("истребитель") or HasL("fighter"):
            if Has("Тяжел") or HasL("heavy"): return "heavy_fighter", tech
            return "light_fighter", tech
        return None, None
    if "NAVAL" in catset:
        if Has("лодка") or HasL("submarine"): return "submarine", tech
        if Has("авианосец") or HasL("carrier"): return "carrier", tech
        if Has("линкор") or HasL("battleship"):
            if Has("линейный") or HasL("battlecruiser"): return "battlecruiser", tech
            return "battleship", tech
        if Has("артшип") or HasL("artillery"): return "artyship", tech
        if Has("крейсер") or HasL("cruiser"): return "cruiser", tech
        if Has("эсминец") or HasL("destroyer"): return "destroyer", tech
        if Has("фрегат") or HasL("frigate"): return "frigate", tech
        return None, None
    # LAND mobile
    if Has("зенитка") or HasL("anti-air") or HasL("flak"): return "mobile_aa", tech
    if Has("ракетниц") or HasL("rocket"): return "mobile_rocket", tech
    if Has("арта") or Has("артилл") or HasL("artillery"): return "mobile_arty", tech
    if Has("Тяжел") or HasL("heavy"): return "heavy", tech
    if Has("Средн") or HasL("medium"): return "med", tech
    if Has("Легк") or HasL("light"): return "light", tech
    return None, None

def cost_for(role, tech, bpid, mass):
    if bpid in VID: return VID[bpid], "VID override"
    if role in ("commander", "subcommander"):
        return V[role], "T%d" % (tech or 0)
    row = V.get(role)
    if row is None: return None, None
    if tech is None: return None, "no tech"
    if tech not in row: return None, "no row[tech=%d]" % tech
    return row[tech], "T%d" % tech

def fmt_nums(vals, suffix="", mult=False):
    out = []
    for v in vals:
        if v is None: out.append("—")
        else:
            try:
                f = float(v)
                if mult: out.append("×%g" % f)
                elif f == int(f): out.append("%d%s" % (int(f), suffix))
                else: out.append("%g%s" % (f, suffix))
            except Exception:
                out.append(str(v) + suffix)
    return " / ".join(out)

def domain_of(cats, role, bpid):
    s = set(cats)
    if role in ("commander",): return "ACU"
    if role in ("subcommander",): return "SACU"
    if "STRUCTURE" in s: return "Оборона"
    if "AIR" in s: return "Воздух"
    if "NAVAL" in s: return "Вода"
    if "LAND" in s: return "Земля"
    # ID-prefix fallback: 3rd char of standard ids (uel->L, uea->A, ues->S, ueb->B).
    # Hooked vanilla units may carry only a partial (merged) Categories list.
    c = (bpid or "").lower()
    if len(c) >= 3:
        m = {"l": "Земля", "a": "Воздух", "s": "Вода", "b": "Оборона"}
        if c[2] in m: return m[c[2]]
    return "Прочее"

def faction_of(cats, bpid):
    s = set(cats)
    for f in ("UEF","CYBRAN","AEON","SERAPHIM"):
        if f in s: return f
    # ID-prefix fallback: 2nd char (ue->UEF, ua->AEON, ur->CYBRAN, xs/xu->SERAPHIM).
    c = (bpid or "").lower()
    if len(c) >= 2:
        m = {"e": "UEF", "a": "AEON", "r": "CYBRAN", "s": "SERAPHIM"}
        if c[1] in m: return m[c[1]]
    return "—"

# ---- walk ----
rows = []
unclassified_vet = []
nfiles = 0
nSkipBuild = 0
for root, dirs, files in os.walk(MOD_ROOT):
    # skip the AI/M28 lua trees etc. — only unit bps
    for fn in files:
        if not fn.lower().endswith("_unit.bp"):
            continue
        path = os.path.join(root, fn)
        nfiles += 1
        try:
            with open(path, "r", encoding="utf-8", errors="replace") as fh:
                text = fh.read()
        except Exception:
            continue
        cats = parse_categories(text)
        # Skip unbuildable units (no BUILTBY* category and not ACU/SACU) — user said ignore those.
        catset = set(cats)
        if not (any(c.startswith("BUILTBY") for c in cats) or "COMMAND" in catset or "SUBCOMMANDER" in catset):
            nSkipBuild += 1
            continue
        desc_raw = parse_field_str(text, "Description") or ""
        bpid = (parse_field_str(text, "BlueprintId") or fn.replace("_unit.bp","")).lower()
        unitname_raw = parse_unitname(text)
        if unitname_raw:
            p = unitname_raw.find(">"); uname = unitname_raw[p+1:] if p>=0 else unitname_raw
        else:
            # fall back to Description (cleaned of LOC tag) so ACUs etc. aren't blank
            p = desc_raw.find(">"); uname = desc_raw[p+1:] if p>=0 else desc_raw
        mass = parse_scalar(text, "BuildCostMass")
        maxhp = parse_scalar(text, "MaxHealth")
        buffs_blk = find_block(text, "Buffs")
        regen = parse_subblock_vals(buffs_blk, "Regen")
        health = parse_subblock_vals(buffs_blk, "Health")
        has_static_vet = re.search(r"(?m)^    Veteran\s*=\s*\{", text) is not None

        role, tech = classify(desc_raw, cats)
        cost, technote = cost_for(role, tech, bpid, mass)
        rel = os.path.relpath(path, MOD_ROOT)
        kind = "added" if rel.lower().startswith(("units"+os.sep, "modacu"+os.sep, "extraunit"+os.sep)) else "hooked"

        if role is None:
            # doesn't classify -> only vets if it had a static Veteran block (placeholder)
            if has_static_vet and mass:
                try: m = float(mass)
                except: m = 60
                if m <= 0: m = 60
                ph = [m, m*2, m*3, m*4, m*5]
                unclassified_vet.append((bpid, uname, desc_raw, " / ".join(str(int(x)) for x in ph), mass, rel))
            continue

        # role is set. If V has no row for this (role,tech), the unit falls back to
        # placeholder thresholds (mass x1..5) when it has a static Veteran block, else it
        # does not vet at all. Surface that explicitly instead of a bare dash.
        cost_note = None
        if cost is None:
            if has_static_vet and mass:
                try: mm = float(mass)
                except: mm = 60
                if mm <= 0: mm = 60
                cost = [mm, mm*2, mm*3, mm*4, mm*5]
                cost_note = "плейсхолдер: нет строки %s для T%s" % (role, tech)
            else:
                cost_note = "не ветеранит (нет строки %s для T%s)" % (role, tech)

        regen_disp = regen if regen else ["DEF"]*5
        health_disp = health if health else ["DEF"]*5
        rows.append({
            "id": bpid, "name": uname, "desc": desc_raw, "role": role,
            "role_ru": ROLE_RU.get(role, role), "tech": tech, "technote": technote,
            "cost": cost, "cost_note": cost_note, "regen": regen, "health": health,
            "regen_disp": regen_disp, "health_disp": health_disp,
            "cats": cats, "domain": domain_of(cats, role, bpid), "faction": faction_of(cats, bpid),
            "mass": mass, "maxhp": maxhp, "rel": rel, "kind": kind,
        })

# ---- write Markdown ----
FAC_ORDER = {"UEF":0, "CYBRAN":1, "AEON":2, "SERAPHIM":3}
ROLE_ORDER = {
    "light":1, "med":2, "heavy":3, "mobile_aa":4, "mobile_arty":5, "mobile_rocket":6,
    "light_fighter":11, "heavy_fighter":12, "interceptor":13, "assault":14, "bomber":15, "air_torpedo":16,
    "frigate":21, "destroyer":22, "cruiser":23, "submarine":24, "artyship":25, "battlecruiser":26, "battleship":27, "carrier":28,
    "light_turret":31, "heavy_turret":32, "static_aa":33, "longrange_arty":34, "rapid_arty":35, "tactical_missile":36,
    "experimental":41, "exp_turret":42,
    "commander":51, "subcommander":52,
}

def md():
    L = []
    L.append("# M&B — ветеранство\n")
    L.append("Два параметра: **Масса** — сколько массы надо выбить у врага, чтобы качнуть вет-уровень "
             "(L1…L5). **Реген** — бафф регена HP/сек на каждом уровне. "
             "Масса едина по классу — правится в `Blueprints.lua` (таблица V). Реген — у каждого юнита в блоке `Buffs`. "
             "`def` = движковый дефолт регена +2/+4/+6/+8/+10. Нестроимые юниты не показаны.\n")

    # class table (where Mass is actually edited)
    L.append("\n## Масса по классу и тирам (править здесь → влияет на всех юнитов класса)\n")
    L.append("| Класс | T1 | T2 | T3 | T4 |")
    L.append("|---|---|---|---|---|")
    def cell(d, t):
        if isinstance(d, dict) and t in d: return " / ".join(str(x) for x in d[t])
        return "—"
    groups = [
        ("Лёгкий", "light"), ("Средний", "med"), ("Тяжёлый", "heavy"),
        ("ПВО (моб.)", "mobile_aa"), ("Арта (моб.)", "mobile_arty"), ("Ракеты (моб.)", "mobile_rocket"),
        ("Лёгкая турель", "light_turret"), ("Тяжёлая турель", "heavy_turret"), ("ПВО (стационар.)", "static_aa"),
        ("Арта (дальноб.)", "longrange_arty"), ("Арта (скоростр.)", "rapid_arty"), ("Такт. ракеты", "tactical_missile"),
        ("Лёгкий истреб.", "light_fighter"), ("Тяжёлый истреб.", "heavy_fighter"), ("Перехватчик", "interceptor"),
        ("Штурмовик", "assault"), ("Бомбардировщик", "bomber"), ("Торпедоносец", "air_torpedo"),
        ("Фрегат", "frigate"), ("Эсминец", "destroyer"), ("Крейсер", "cruiser"), ("Подлодка", "submarine"),
        ("Арткорабль", "artyship"), ("Лин. крейсер", "battlecruiser"), ("Линкор", "battleship"), ("Авианосец", "carrier"),
        ("Эксперимент.", "experimental"), ("Эксп. турель", "exp_turret"),
    ]
    for ru, key in groups:
        d = V[key]
        L.append("| %s | %s | %s | %s | %s |" % (ru, cell(d,1), cell(d,2), cell(d,3), cell(d,4)))
    L.append("| ACU | 1200 / 2600 / 4800 / 7600 / 12800 (любой тир) ||||")
    L.append("| SACU | 1000 / 2200 / 3800 / 6600 / 9200 (любой тир) ||||")

    # per-faction unit tables
    facs = sorted(set(r["faction"] for r in rows), key=lambda f: (FAC_ORDER.get(f, 9), f))
    for fac in facs:
        items = [r for r in rows if r["faction"] == fac]
        items.sort(key=lambda r: (ROLE_ORDER.get(r["role"], 99), r["tech"] or 0, (r["name"] or "").lower()))
        L.append("\n## %s (%d)\n" % (fac, len(items)))
        L.append("| T | Тип | Юнит | Масса L1–L5 | Реген L1–L5 |")
        L.append("|---|---|---|---|---|")
        for r in items:
            mass_s = fmt_nums(r["cost"]) if r["cost"] else "⚠"
            regen_s = "def" if r["regen"] is None else fmt_nums(r["regen"])
            if r["health"] is not None:
                regen_s += "  HP " + fmt_nums(r["health"], mult=True)
            name = (r["name"] or "").replace("|", "/").strip()
            L.append("| %s | %s | %s (%s) | %s | %s |" % (
                r["tech"] or "—", r["role_ru"], name, r["id"], mass_s, regen_s))
    return "\n".join(L) + "\n"

md_text = md()
with open(OUT_MD, "w", encoding="utf-8") as f:
    f.write(md_text)

# ---- gaps + unclassified -> separate file (keep main table clean) ----
OUT_GAPS = os.path.join(DESKTOP, "M&B_Veterancy_Пробелы.txt")
with open(OUT_GAPS, "w", encoding="utf-8") as f:
    L = ["# M&B — пробелы ветеранства (то, что пока качается криво или не качается)\n"]
    gaps = [r for r in rows if r["cost_note"]]
    if gaps:
        L.append("\n## Есть класс, но в таблице V нет строки для их тира\n")
        L.append("В игре получают пороги масса×1..5 (плейсхолдер) или не качаются.\n")
        L.append("| ID | Юнит | Тип | T | Масса | |")
        L.append("|---|---|---|---|---|---|")
        for r in sorted(gaps, key=lambda r:(r["role"], r["id"])):
            what = "плейсхолдер" if r["cost"] is not None else "не ветеранит"
            L.append("| %s | %s | %s | %s | %s | %s |" % (
                r["id"], (r["name"] or "").replace("|","/"), r["role_ru"], r["tech"] or "—", r["mass"] or "—", what))
    if unclassified_vet:
        L.append("\n## Боевые юниты без класса (не попали в классификацию — качаются по масса×1..5)\n")
        L.append("Это в основном экспериментальные, бомбардировщики, торпедные/ракетные турели, боты. "
                 "Их надо научить классифицировать (отдельная задача).\n")
        L.append("| ID | Юнит | Описание | Масса | Файл |")
        L.append("|---|---|---|---|---|")
        for b,u,d,c,m,rel in sorted(unclassified_vet):
            dd = (d or "").replace("|","/")
            p = dd.find(">")
            if p >= 0: dd = dd[p+1:]
            L.append("| %s | %s | %s | %s | %s |" % (b,(u or "").replace("|","/"),dd,m,rel))
    f.write("\n".join(L) + "\n")

# ---- write CSV (UTF-8 BOM for Excel) ----
try:
    _csv_f = open(OUT_CSV, "w", encoding="utf-8-sig", newline="")
except PermissionError:
    _csv_f = None
    print("CSV не записан: файл открыт (закройте Excel и перезапустите).")
if _csv_f:
    f = _csv_f
    w = csv.writer(f)
    w.writerow(["Фракция","T","Тип","Юнит","ID",
                "Mass_L1","Mass_L2","Mass_L3","Mass_L4","Mass_L5",
                "Regen_L1","Regen_L2","Regen_L3","Regen_L4","Regen_L5",
                "Health_L1","Health_L2","Health_L3","Health_L4","Health_L5"])
    for r in sorted(rows, key=lambda r:(FAC_ORDER.get(r["faction"],9), ROLE_ORDER.get(r["role"],99), r["tech"] or 0, (r["name"] or "").lower())):
        def pad(v):
            v = (list(v) + [""]*5)[:5]
            out = []
            for x in v:
                try:
                    fx = float(x)
                    out.append(int(fx) if fx == int(fx) else fx)
                except (ValueError, TypeError):
                    out.append(x)
            return out
        cost = pad(r["cost"]) if r["cost"] else [""]*5
        reg  = pad(r["regen"]) if r["regen"] else ["def"]*5
        hp   = pad(r["health"]) if r["health"] else [""]*5
        w.writerow([r["faction"], r["tech"] or "", r["role_ru"], r["name"], r["id"], *cost, *reg, *hp])
    f.close()

print("rows:", len(rows), "| unclassified:", len(unclassified_vet), "| unbuildable skipped:", nSkipBuild, "| files:", nfiles)
print("MD  ->", OUT_MD)
print("CSV ->", OUT_CSV)
print("GAP ->", OUT_GAPS)
