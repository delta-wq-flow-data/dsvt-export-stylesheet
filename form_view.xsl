<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- ─── Root ───────────────────────────────────────────────────────────────── -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>
          <xsl:value-of select="DSVTFormSubmission/DisplayData/@formType"/>
          <xsl:text> — DSVT Form Submission</xsl:text>
        </title>
        <style>
          *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #0f172a;
            background: #f1f5f9;
          }

          .page {
            max-width: 920px;
            margin: 32px auto;
            padding: 0 16px 48px;
          }

          /* ── Header ─────────────────────────────────────────────────────── */
          .doc-header {
            display: flex;
            align-items: center;
            gap: 16px;
            background: #1e3a5f;
            color: white;
            border-radius: 8px 8px 0 0;
            padding: 20px 24px;
            margin-bottom: 0;
          }
          .doc-header .brand { display: flex; flex-direction: column; gap: 2px; }
          .doc-header .brand-name {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            opacity: 0.7;
          }
          .doc-header .form-type {
            font-size: 20px;
            font-weight: 700;
          }
          .doc-header .meta {
            margin-left: auto;
            text-align: right;
            font-size: 12px;
            opacity: 0.75;
          }

          /* ── Card (shared by sections) ───────────────────────────────────── */
          .card {
            background: white;
            border: 1px solid #e2e8f0;
            border-top: none;
            padding: 20px 24px;
          }
          .card:last-child {
            border-radius: 0 0 8px 8px;
          }

          /* ── Section header ─────────────────────────────────────────────── */
          .section-label {
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 6px;
          }
          .section-divider {
            border: none;
            border-top: 1px solid #e2e8f0;
            margin-bottom: 16px;
          }

          /* ── Fields grid ─────────────────────────────────────────────────── */
          .fields {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px 24px;
          }
          .field { display: flex; flex-direction: column; gap: 3px; }
          .field.full { grid-column: 1 / -1; }

          .field-label {
            font-size: 12px;
            font-weight: 600;
            color: #374151;
            line-height: 1.3;
          }
          .field-value {
            font-size: 14px;
            color: #0f172a;
          }
          .field-value.empty { color: #94a3b8; }

          /* ── Badges ──────────────────────────────────────────────────────── */
          .badges {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            padding-top: 2px;
          }
          .badge {
            display: inline-flex;
            align-items: center;
            border-radius: 9999px;
            padding: 2px 10px;
            font-size: 12px;
            font-weight: 500;
            background: #0f172a;
            color: #f8fafc;
            white-space: nowrap;
          }

          /* ── Tables ──────────────────────────────────────────────────────── */
          .table-wrap {
            overflow-x: auto;
            margin-top: 12px;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
          }
          .table-name {
            font-size: 12px;
            font-weight: 600;
            color: #475569;
            padding: 8px 12px 0;
            background: #f8fafc;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
          }
          th, td {
            padding: 8px 10px;
            text-align: left;
            border: 1px solid #e2e8f0;
            white-space: nowrap;
          }
          thead { background: #f1f5f9; }
          th { font-weight: 600; color: #374151; font-size: 12px; }
          td { color: #0f172a; }
          tbody tr:last-child td { border-bottom: none; }

          /* ── Spacing between sections ─────────────────────────────────────── */
          .card + .card { border-top: 1px solid #e2e8f0; }
        </style>
      </head>
      <body>
        <div class="page">
          <div class="doc-header">
            <div class="brand">
              <span class="brand-name">DSVT · Delta Site Visit Tool</span>
              <span class="form-type">
                <xsl:value-of select="DSVTFormSubmission/DisplayData/@formType"/>
              </span>
            </div>
          </div>
          <xsl:apply-templates select="DSVTFormSubmission/DisplayData/Section"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ─── Section ──────────────────────────────────────────────────────────── -->
  <xsl:template match="Section">
    <div class="card">
      <p class="section-label"><xsl:value-of select="@name"/></p>
      <hr class="section-divider"/>
      <div class="fields">
        <xsl:apply-templates select="Field"/>
      </div>
      <xsl:apply-templates select="Table"/>
    </div>
  </xsl:template>

  <!-- ─── Plain field ──────────────────────────────────────────────────────── -->
  <xsl:template match="Field[not(@type)]">
    <div class="field">
      <span class="field-label"><xsl:value-of select="@label"/></span>
      <xsl:choose>
        <xsl:when test="normalize-space(.) = '' or normalize-space(.) = '—'">
          <span class="field-value empty">—</span>
        </xsl:when>
        <xsl:otherwise>
          <span class="field-value"><xsl:value-of select="."/></span>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <!-- ─── List field (badges) ──────────────────────────────────────────────── -->
  <xsl:template match="Field[@type='list']">
    <div class="field full">
      <span class="field-label"><xsl:value-of select="@label"/></span>
      <xsl:choose>
        <xsl:when test="count(Item) = 0">
          <span class="field-value empty">—</span>
        </xsl:when>
        <xsl:otherwise>
          <div class="badges">
            <xsl:for-each select="Item">
              <span class="badge"><xsl:value-of select="."/></span>
            </xsl:for-each>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <!-- ─── Table ────────────────────────────────────────────────────────────── -->
  <xsl:template match="Table">
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <xsl:for-each select="Columns/Column">
              <th><xsl:value-of select="."/></th>
            </xsl:for-each>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="Row">
            <tr>
              <xsl:for-each select="Cell">
                <td>
                  <xsl:choose>
                    <xsl:when test="normalize-space(.) = '' or normalize-space(.) = '—'">
                      <span style="color:#94a3b8">—</span>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </xsl:for-each>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
